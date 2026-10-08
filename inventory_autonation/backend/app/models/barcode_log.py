from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base


class BarcodeLog(Base):
    __tablename__ = "barcode_logs"

    id = Column(Integer, primary_key=True, index=True)
    barcode = Column(String(100), nullable=False, index=True)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=True)
    scanned_by_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    found = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    product = relationship("Product", back_populates="barcode_logs")
    scanned_by_user = relationship("User", back_populates="barcode_logs")
