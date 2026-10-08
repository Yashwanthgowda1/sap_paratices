from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from typing import List, Optional
from app.database import get_db
from app.models.product import Product
from app.schemas.product import ProductCreate, ProductUpdate, ProductResponse
from app.core.deps import get_current_user, require_owner
from app.models.user import User

router = APIRouter()


@router.get("/", response_model=List[ProductResponse])
def list_products(
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = None,
    category_id: Optional[int] = None,
    low_stock: bool = False,
    out_of_stock: bool = False,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(Product).options(
        joinedload(Product.category),
        joinedload(Product.supplier),
    )
    if search:
        query = query.filter(
            Product.name.ilike(f"%{search}%") | Product.barcode.ilike(f"%{search}%")
        )
    if category_id:
        query = query.filter(Product.category_id == category_id)
    if low_stock:
        query = query.filter(
            Product.stock_quantity <= Product.min_stock_level,
            Product.stock_quantity > 0,
        )
    if out_of_stock:
        query = query.filter(Product.stock_quantity == 0)
    return query.offset(skip).limit(limit).all()


@router.get("/stats")
def get_product_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    total = db.query(func.count(Product.id)).scalar() or 0
    out_of_stock = db.query(func.count(Product.id)).filter(Product.stock_quantity == 0).scalar() or 0
    low_stock = db.query(func.count(Product.id)).filter(
        Product.stock_quantity <= Product.min_stock_level, Product.stock_quantity > 0
    ).scalar() or 0
    total_value = db.query(
        func.sum(Product.stock_quantity * Product.purchase_price)
    ).scalar() or 0
    return {
        "total": total,
        "out_of_stock": out_of_stock,
        "low_stock": low_stock,
        "total_value": float(total_value),
    }


@router.get("/{product_id}", response_model=ProductResponse)
def get_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    product = (
        db.query(Product)
        .options(joinedload(Product.category), joinedload(Product.supplier))
        .filter(Product.id == product_id)
        .first()
    )
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


@router.post("/", response_model=ProductResponse)
def create_product(
    product_data: ProductCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    existing = db.query(Product).filter(Product.barcode == product_data.barcode).first()
    if existing:
        raise HTTPException(status_code=400, detail="Product with this barcode already exists")
    product = Product(**product_data.model_dump(), created_by_id=current_user.id)
    db.add(product)
    db.commit()
    db.refresh(product)
    return product


@router.put("/{product_id}", response_model=ProductResponse)
def update_product(
    product_id: int,
    update_data: ProductUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    for k, v in update_data.model_dump(exclude_unset=True).items():
        setattr(product, k, v)
    db.commit()
    db.refresh(product)
    return product


@router.delete("/{product_id}")
def delete_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_owner),
):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    db.delete(product)
    db.commit()
    return {"message": "Product deleted"}
