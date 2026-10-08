import csv
import io
from datetime import date, datetime
from typing import Optional
from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.database import get_db
from app.models.sale import Sale, SaleItem
from app.models.product import Product
from app.core.deps import get_current_user
from app.models.user import User

router = APIRouter()


@router.get("/dashboard")
def get_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    today = date.today()
    today_start = datetime.combine(today, datetime.min.time())
    today_end = datetime.combine(today, datetime.max.time())
    month_start = today.replace(day=1)

    total_products = db.query(func.count(Product.id)).scalar() or 0
    out_of_stock = db.query(func.count(Product.id)).filter(Product.stock_quantity == 0).scalar() or 0
    low_stock = db.query(func.count(Product.id)).filter(
        Product.stock_quantity <= Product.min_stock_level, Product.stock_quantity > 0
    ).scalar() or 0
    total_stock_value = db.query(
        func.sum(Product.stock_quantity * Product.purchase_price)
    ).scalar() or 0.0

    today_sales = db.query(func.sum(Sale.final_amount)).filter(
        Sale.created_at.between(today_start, today_end)
    ).scalar() or 0.0
    today_count = db.query(func.count(Sale.id)).filter(
        Sale.created_at.between(today_start, today_end)
    ).scalar() or 0
    month_sales = db.query(func.sum(Sale.final_amount)).filter(
        Sale.created_at >= datetime.combine(month_start, datetime.min.time())
    ).scalar() or 0.0

    total_profit = db.query(
        func.sum((SaleItem.unit_price - Product.purchase_price) * SaleItem.quantity)
    ).join(Product, SaleItem.product_id == Product.id).scalar() or 0.0

    recent_sales = db.query(Sale).order_by(Sale.created_at.desc()).limit(5).all()
    low_stock_products = (
        db.query(Product)
        .filter(Product.stock_quantity <= Product.min_stock_level)
        .order_by(Product.stock_quantity.asc())
        .limit(10)
        .all()
    )

    # Sales last 7 days
    from datetime import timedelta
    daily_sales = []
    for i in range(6, -1, -1):
        d = today - timedelta(days=i)
        d_start = datetime.combine(d, datetime.min.time())
        d_end = datetime.combine(d, datetime.max.time())
        amount = db.query(func.sum(Sale.final_amount)).filter(
            Sale.created_at.between(d_start, d_end)
        ).scalar() or 0.0
        daily_sales.append({"date": d.strftime("%b %d"), "amount": float(amount)})

    return {
        "total_products": total_products,
        "out_of_stock": out_of_stock,
        "low_stock": low_stock,
        "total_stock_value": float(total_stock_value),
        "today_sales": float(today_sales),
        "today_count": today_count,
        "month_sales": float(month_sales),
        "total_profit": float(total_profit),
        "daily_sales": daily_sales,
        "recent_sales": [
            {
                "id": s.id,
                "invoice_number": s.invoice_number,
                "final_amount": s.final_amount,
                "payment_method": s.payment_method,
                "created_at": s.created_at.isoformat(),
            }
            for s in recent_sales
        ],
        "low_stock_products": [
            {
                "id": p.id,
                "name": p.name,
                "stock_quantity": p.stock_quantity,
                "min_stock_level": p.min_stock_level,
            }
            for p in low_stock_products
        ],
    }


@router.get("/sales")
def get_sales_report(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(Sale)
    if start_date:
        query = query.filter(Sale.created_at >= datetime.combine(start_date, datetime.min.time()))
    if end_date:
        query = query.filter(Sale.created_at <= datetime.combine(end_date, datetime.max.time()))
    sales = query.order_by(Sale.created_at.desc()).all()
    total = sum(s.final_amount for s in sales)
    total_discount = sum(s.discount for s in sales)
    return {
        "total_sales": float(total),
        "total_discount": float(total_discount),
        "count": len(sales),
        "sales": [
            {
                "id": s.id,
                "invoice_number": s.invoice_number,
                "total_amount": s.total_amount,
                "discount": s.discount,
                "final_amount": s.final_amount,
                "payment_method": s.payment_method,
                "created_at": s.created_at.isoformat(),
            }
            for s in sales
        ],
    }


@router.get("/stock")
def get_stock_report(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    products = db.query(Product).all()
    total_value = sum(p.stock_quantity * p.purchase_price for p in products)
    return {
        "total_products": len(products),
        "total_value": float(total_value),
        "products": [
            {
                "id": p.id,
                "name": p.name,
                "barcode": p.barcode,
                "stock_quantity": p.stock_quantity,
                "min_stock_level": p.min_stock_level,
                "purchase_price": p.purchase_price,
                "selling_price": p.selling_price,
                "stock_value": p.stock_quantity * p.purchase_price,
                "status": (
                    "out_of_stock"
                    if p.stock_quantity == 0
                    else "low_stock"
                    if p.stock_quantity <= p.min_stock_level
                    else "ok"
                ),
            }
            for p in products
        ],
    }


@router.get("/product-sales")
def get_product_sales_report(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = (
        db.query(
            Product.id,
            Product.name,
            Product.barcode,
            func.sum(SaleItem.quantity).label("total_sold"),
            func.sum(SaleItem.subtotal).label("total_revenue"),
            func.sum(
                (SaleItem.unit_price - Product.purchase_price) * SaleItem.quantity
            ).label("total_profit"),
        )
        .join(SaleItem, Product.id == SaleItem.product_id)
        .join(Sale, SaleItem.sale_id == Sale.id)
    )
    if start_date:
        query = query.filter(Sale.created_at >= datetime.combine(start_date, datetime.min.time()))
    if end_date:
        query = query.filter(Sale.created_at <= datetime.combine(end_date, datetime.max.time()))
    results = query.group_by(Product.id).order_by(func.sum(SaleItem.quantity).desc()).all()
    return {
        "products": [
            {
                "id": r.id,
                "name": r.name,
                "barcode": r.barcode,
                "total_sold": r.total_sold,
                "total_revenue": float(r.total_revenue),
                "total_profit": float(r.total_profit),
            }
            for r in results
        ]
    }


@router.get("/export/sales")
def export_sales_csv(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(Sale)
    if start_date:
        query = query.filter(Sale.created_at >= datetime.combine(start_date, datetime.min.time()))
    if end_date:
        query = query.filter(Sale.created_at <= datetime.combine(end_date, datetime.max.time()))
    sales = query.order_by(Sale.created_at.desc()).all()

    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["Invoice", "Total Amount", "Discount", "Final Amount", "Payment Method", "Date"])
    for s in sales:
        writer.writerow([
            s.invoice_number, s.total_amount, s.discount,
            s.final_amount, s.payment_method, s.created_at.strftime("%Y-%m-%d %H:%M"),
        ])
    output.seek(0)
    return StreamingResponse(
        iter([output.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=sales_report.csv"},
    )


@router.get("/export/stock")
def export_stock_csv(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    products = db.query(Product).all()
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["Name", "Barcode", "Stock", "Min Level", "Purchase Price", "Selling Price", "Stock Value", "Status"])
    for p in products:
        status = "Out of Stock" if p.stock_quantity == 0 else "Low Stock" if p.stock_quantity <= p.min_stock_level else "OK"
        writer.writerow([
            p.name, p.barcode, p.stock_quantity, p.min_stock_level,
            p.purchase_price, p.selling_price, p.stock_quantity * p.purchase_price, status,
        ])
    output.seek(0)
    return StreamingResponse(
        iter([output.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=stock_report.csv"},
    )
