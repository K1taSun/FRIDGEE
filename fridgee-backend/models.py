from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class Product(BaseModel):
    id: str                
    name: str              
    expiryDate: datetime    
    isOpened: bool = False  
    barcode: Optional[str] = None 
    quantity: float         