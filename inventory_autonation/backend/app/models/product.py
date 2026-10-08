from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base


class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False, index=True)
    barcode = Column(String(100), unique=True, index=True, nullable=False)
    category_id = Column(Integer, ForeignKey("categories.id"), nullable=True)
    brand = Column(String(100))
    purchase_price = Column(Float, nullable=False)
    selling_price = Column(Float, nullable=False)
    stock_quantity = Column(Integer, default=0, nullable=False)
    expiry_date = Column(Date, nullable=True)
    supplier_id = Column(Integer, ForeignKey("suppliers.id"), nullable=True)
    image_url = Column(String(500), nullable=True)
    storage_location = Column(String(200), nullable=True)
    description = Column(Text, nullable=True)
    min_stock_level = Column(Integer, default=10)
    created_by_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    category = relationship("Category", back_populates="products")
    supplier = relationship("Supplier", back_populates="products")
    stock_transactions = relationship("StockTransaction", back_populates="product")
    sale_items = relationship("SaleItem", back_populates="product")
    barcode_logs = relationship("BarcodeLog", back_populates="product")
