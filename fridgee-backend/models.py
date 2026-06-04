from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, List
import uuid
import random
import string

def generate_invite_code():
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))

class User(BaseModel):
    id: str # UUID urządzenia mobilnego wysyłane w nagłówku X-Device-ID
    nickname: Optional[str] = "Domownik"
    activeInstanceId: Optional[str] = None # Aktywne gospodarstwo domowe

class Instance(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    code: str = Field(default_factory=generate_invite_code) # Kod zaproszenia domowników
    members: List[str] = []

class StorageObject(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    instanceId: str  # Powiązanie z gospodarstwem domowym
    name: str        # Np. "Lodówka główna", "Zamrażarka szufladowa", "Szafka narożna"
    type: str        # Kategoria obiektu: lodówka, zamrażarka, szafka, spiżarnia

class Product(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    instanceId: str       # Do którego gospodarstwa należy produkt
    storageObjectId: str  # Do którego konkretnie obiektu (np. lodówki) należy produkt
    name: str              
    brand: Optional[str] = None
    expiryDate: datetime    
    isOpened: bool = False  
    barcode: Optional[str] = None 
    quantity: float
    caloriesPer100g: Optional[float] = None
    category: Optional[str] = "inne"