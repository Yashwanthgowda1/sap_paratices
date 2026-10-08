from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class SupplierBase(BaseModel):
    name: str
    contact_number: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None


class SupplierCreate(SupplierBase):
    pass


class SupplierUpdate(BaseModel):
    name: Optional[str] = None
    contact_number: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None


class SupplierResponse(SupplierBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
