from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime


class CategoryInfo(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True


class SupplierInfo(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True


class ProductBase(BaseModel):
    name: str
    barcode: str
    category_id: Optional[int] = None
    brand: Optional[str] = None
    purchase_price: float
    selling_price: float
    stock_quantity: int = 0
    expiry_date: Optional[date] = None
    supplier_id: Optional[int] = None
    image_url: Optional[str] = None
    storage_location: Optional[str] = None
    description: Optional[str] = None
    min_stock_level: int = 10


class ProductCreate(ProductBase):
    pass


class ProductUpdate(BaseModel):
    name: Optional[str] = None
    category_id: Optional[int] = None
    brand: Optional[str] = None
    purchase_price: Optional[float] = None
    selling_price: Optional[float] = None
    expiry_date: Optional[date] = None
    supplier_id: Optional[int] = None
    image_url: Optional[str] = None
    storage_location: Optional[str] = None
    description: Optional[str] = None
    min_stock_level: Optional[int] = None


class ProductResponse(ProductBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    category: Optional[CategoryInfo] = None
    supplier: Optional[SupplierInfo] = None

    class Config:
        from_attributes = True
