import random
import string
from datetime import date, datetime
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from app.database import get_db
from app.models.sale import Sale, SaleItem
from app.models.product import Product
from app.models.stock import StockTransaction, TransactionType
from app.schemas.sale import SaleCreate, SaleResponse
from app.core.deps import get_current_user
from app.models.user import User

router = APIRouter()


def generate_invoice_number() -> str:
    date_str = datetime.now().strftime("%Y%m%d")
    suffix = "".join(random.choices(string.ascii_uppercase + string.digits, k=6))
    return f"INV-{date_str}-{suffix}"


@router.post("/", response_model=SaleResponse)
def create_sale(
    sale_data: SaleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not sale_data.items:
        raise HTTPException(status_code=400, detail="Sale must have at least one item")

    total_amount = 0.0
    resolved_items = []

    for item in sale_data.items:
        product = db.query(Product).filter(Product.id == item.product_id).with_for_update().first()
        if not product:
            raise HTTPException(status_code=404, detail=f"Product {item.product_id} not found")
        if product.stock_quantity < item.quantity:
            raise HTTPException(
                status_code=400,
                detail=f"Insufficient stock for '{product.name}'. Available: {product.stock_quantity}",
            )
        subtotal = item.unit_price * item.quantity
        total_amount += subtotal
        resolved_items.append((product, item, subtotal))

    final_amount = max(0.0, total_amount - sale_data.discount)

    sale = Sale(
        invoice_number=generate_invoice_number(),
        total_amount=total_amount,
        discount=sale_data.discount,
        final_amount=final_amount,
        payment_method=sale_data.payment_method,
        notes=sale_data.notes,
        created_by_id=current_user.id,
    )
    db.add(sale)
    db.flush()

    for product, item, subtotal in resolved_items:
        db.add(
            SaleItem(
                sale_id=sale.id,
                product_id=item.product_id,
                quantity=item.quantity,
                unit_price=item.unit_price,
                subtotal=subtotal,
            )
        )
        product.stock_quantity -= item.quantity
        db.add(
            StockTransaction(
                product_id=product.id,
                transaction_type=TransactionType.reduce,
                quantity=item.quantity,
                notes=f"Sale - {sale.invoice_number}",
                created_by_id=current_user.id,
            )
        )

    db.commit()
    db.refresh(sale)
    # Reload with items + products
    return (
        db.query(Sale)
        .options(joinedload(Sale.items).joinedload(SaleItem.product))
        .filter(Sale.id == sale.id)
        .first()
    )


@router.get("/summary")
def get_sales_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    today = date.today()
    today_start = datetime.combine(today, datetime.min.time())
    today_end = datetime.combine(today, datetime.max.time())
    month_start = today.replace(day=1)

    today_sales = db.query(func.sum(Sale.final_amount)).filter(
        Sale.created_at.between(today_start, today_end)
    ).scalar() or 0.0
    today_count = db.query(func.count(Sale.id)).filter(
        Sale.created_at.between(today_start, today_end)
    ).scalar() or 0
    month_sales = db.query(func.sum(Sale.final_amount)).filter(
        Sale.created_at >= datetime.combine(month_start, datetime.min.time())
    ).scalar() or 0.0

    return {
        "today_sales": float(today_sales),
        "today_count": today_count,
        "month_sales": float(month_sales),
    }


@router.get("/", response_model=List[SaleResponse])
def list_sales(
    skip: int = 0,
    limit: int = 50,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(Sale).options(joinedload(Sale.items).joinedload(SaleItem.product))
    if start_date:
        query = query.filter(Sale.created_at >= datetime.combine(start_date, datetime.min.time()))
    if end_date:
        query = query.filter(Sale.created_at <= datetime.combine(end_date, datetime.max.time()))
    return query.order_by(Sale.created_at.desc()).offset(skip).limit(limit).all()


@router.get("/{sale_id}", response_model=SaleResponse)
def get_sale(
    sale_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    sale = (
        db.query(Sale)
        .options(joinedload(Sale.items).joinedload(SaleItem.product))
        .filter(Sale.id == sale_id)
        .first()
    )
    if not sale:
        raise HTTPException(status_code=404, detail="Sale not found")
    return sale
