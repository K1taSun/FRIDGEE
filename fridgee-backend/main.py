from fastapi import FastAPI, HTTPException, Header, Depends
from typing import Optional, List
from models import Product, User, Instance, StorageObject

app = FastAPI(title="Fridgee Core API")

# Symulacja bazy danych (płaskie kolekcje NoSQL)
users_db = {}
instances_db = {}
storage_objects_db = {}
products_db = {}

# Dependency - Identyfikacja bezhasłowa na podstawie X-Device-ID urządzenia
def get_current_user(x_device_id: Optional[str] = Header(None)) -> User:
    if not x_device_id:
        raise HTTPException(status_code=400, detail="Brak nagłówka identyfikującego urządzenie X-Device-ID")
    if x_device_id not in users_db:
        users_db[x_device_id] = User(id=x_device_id)
    return users_db[x_device_id]

# ─── OBSŁUGA GOSPODARSTW (INSTANCJI) ───

@app.post("/instances/create", response_model=Instance)
def create_instance(name: str, user: User = Depends(get_current_user)):
    new_instance = Instance(name=name, members=[user.id])
    instances_db[new_instance.id] = new_instance
    user.activeInstanceId = new_instance.id
    
    # Automatycznie twórz domyślną lodówkę i szafkę dla nowego gospodarstwa
    default_fridge = StorageObject(instanceId=new_instance.id, name="Lodówka", type="lodówka")
    default_pantry = StorageObject(instanceId=new_instance.id, name="Szafka", type="szafka")
    storage_objects_db[default_fridge.id] = default_fridge
    storage_objects_db[default_pantry.id] = default_pantry
    
    return new_instance

@app.post("/instances/join/{invite_code}", response_model=Instance)
def join_instance(invite_code: str, user: User = Depends(get_current_user)):
    instance = next((inst for inst in instances_db.values() if inst.code == invite_code.upper()), None)
    if not instance:
        raise HTTPException(status_code=404, detail="Nieprawidłowy kod gospodarstwa")
    if user.id not in instance.members:
        instance.members.append(user.id)
    user.activeInstanceId = instance.id
    return instance

# ─── OBSŁUGA OBIEKTÓW MAGAZYNOWYCH (LODÓWKI, SZAFKI) ───

@app.post("/storage-objects", response_model=StorageObject)
def add_storage_object(name: str, type: str, user: User = Depends(get_current_user)):
    """Dodaje nowy obiekt (np. Szafka, Lodówka) do aktywnego gospodarstwa użytkownika."""
    if not user.activeInstanceId:
        raise HTTPException(status_code=400, detail="Musisz najpierw należeć do gospodarstwa domowego")
    
    new_object = StorageObject(instanceId=user.activeInstanceId, name=name, type=type.lower())
    storage_objects_db[new_object.id] = new_object
    return new_object

@app.get("/storage-objects", response_model=List[StorageObject])
def get_storage_objects(user: User = Depends(get_current_user)):
    """Pobiera wszystkie zarejestrowane obiekty w gospodarstwie domowym."""
    if not user.activeInstanceId:
        return []
    return [obj for obj in storage_objects_db.values() if obj.instanceId == user.activeInstanceId]

# ─── PRODUKTY ───

@app.post("/products", response_model=Product)
def add_product(product: Product, user: User = Depends(get_current_user)):
    if not user.activeInstanceId:
        raise HTTPException(status_code=400, detail="Brak aktywnego gospodarstwa")
    
    # Walidacja czy obiekt docelowy (np. ta konkretna szafka) istnieje w gospodarstwie
    target_obj = storage_objects_db.get(product.storageObjectId)
    if not target_obj or target_obj.instanceId != user.activeInstanceId:
        raise HTTPException(status_code=400, detail="Wybrany obiekt magazynowy nie istnieje w Twoim gospodarstwie")
        
    product.instanceId = user.activeInstanceId
    products_db[product.id] = product
    return product

@app.get("/products", response_model=List[Product])
def get_products(storage_object_id: Optional[str] = None, user: User = Depends(get_current_user)):
    """Pobiera produkty. Można filtrować po id konkretnego obiektu (np. konkretnej szafki)."""
    if not user.activeInstanceId:
        return []
    
    user_products = [p for p in products_db.values() if p.instanceId == user.activeInstanceId]
    if storage_object_id:
        user_products = [p for p in user_products if p.storageObjectId == storage_object_id]
    return user_products