from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from app.models.sale import PaymentMethod


class SaleItemCreate(BaseModel):
    product_id: int
    quantity: int
    unit_price: float


class SaleCreate(BaseModel):
    items: List[SaleItemCreate]
    discount: float = 0.0
    payment_method: PaymentMethod = PaymentMethod.cash
    notes: Optional[str] = None


class ProductInSaleItem(BaseModel):
    id: int
    name: str
    barcode: str

    class Config:
        from_attributes = True


class SaleItemResponse(BaseModel):
    id: int
    product_id: int
    quantity: int
    unit_price: float
    subtotal: float
    product: Optional[ProductInSaleItem] = None

    class Config:
        from_attributes = True


class SaleResponse(BaseModel):
    id: int
    invoice_number: str
    total_amount: float
    discount: float
    final_amount: float
    payment_method: PaymentMethod
    notes: Optional[str]
    created_by_id: Optional[int]
    created_at: datetime
    items: List[SaleItemResponse] = []

    class Config:
        from_attributes = True
