from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app.database import get_db
from app.models.stock import StockTransaction, TransactionType
from app.models.product import Product
from app.schemas.stock import StockTransactionCreate, StockTransactionResponse
from app.core.deps import get_current_user
from app.models.user import User

router = APIRouter()


@router.get("/", response_model=List[StockTransactionResponse])
def list_transactions(
    product_id: Optional[int] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(StockTransaction).options(joinedload(StockTransaction.product))
    if product_id:
        query = query.filter(StockTransaction.product_id == product_id)
    return query.order_by(StockTransaction.created_at.desc()).offset(skip).limit(limit).all()


@router.post("/", response_model=StockTransactionResponse)
def create_transaction(
    data: StockTransactionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    product = db.query(Product).filter(Product.id == data.product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    if data.transaction_type == TransactionType.add:
        product.stock_quantity += data.quantity
    elif data.transaction_type in [TransactionType.reduce, TransactionType.damaged]:
        if product.stock_quantity < data.quantity:
            raise HTTPException(status_code=400, detail="Insufficient stock")
        product.stock_quantity -= data.quantity
    elif data.transaction_type == TransactionType.adjustment:
        product.stock_quantity = data.quantity

    transaction = StockTransaction(**data.model_dump(), created_by_id=current_user.id)
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return transaction
