from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from app.models.stock import TransactionType


class StockTransactionCreate(BaseModel):
    product_id: int
    transaction_type: TransactionType
    quantity: int
    notes: Optional[str] = None


class ProductInStock(BaseModel):
    id: int
    name: str
    barcode: str

    class Config:
        from_attributes = True


class StockTransactionResponse(BaseModel):
    id: int
    product_id: int
    transaction_type: TransactionType
    quantity: int
    notes: Optional[str]
    created_by_id: Optional[int]
    created_at: datetime
    product: Optional[ProductInStock] = None

    class Config:
        from_attributes = True
