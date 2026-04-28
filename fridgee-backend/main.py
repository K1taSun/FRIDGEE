from fastapi import FastAPI
from models import Product
import uuid
from datetime import datetime, timedelta

app = FastAPI(title="Fridgee API")

#Przykładowy produkt z Biedronki
fake_database = [
    Product(
        id=str(uuid.uuid4()),
        name="Mleko 3.2%",
        expiryDate=datetime.now() + timedelta(days=3),
        isOpened=True,
        barcode="5900000000000",
        quantity=1.0
    )
]

@app.get("/")
def read_root():
    return {"message": "Witaj w inteligentnym systemie Fridgee!"}

# Endpoint do pobierania listy produktów
@app.get("/products", response_model=list[Product])
def get_products():
    return fake_database

# Endpoint do dodawania nowego produktu
@app.post("/products", response_model=Product)
def add_product(product: Product):
    fake_database.append(product)
    return product