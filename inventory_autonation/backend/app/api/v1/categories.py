from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app.models.category import Category
from app.schemas.category import CategoryCreate, CategoryUpdate, CategoryResponse
from app.core.deps import get_current_user, require_owner
from app.models.user import User

router = APIRouter()


@router.get("/", response_model=List[CategoryResponse])
def list_categories(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return db.query(Category).all()


@router.post("/", response_model=CategoryResponse)
def create_category(
    cat_data: CategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    existing = db.query(Category).filter(Category.name == cat_data.name).first()
    if existing:
        raise HTTPException(status_code=400, detail="Category already exists")
    cat = Category(**cat_data.model_dump())
    db.add(cat)
    db.commit()
    db.refresh(cat)
    return cat


@router.put("/{cat_id}", response_model=CategoryResponse)
def update_category(
    cat_id: int,
    update_data: CategoryUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_owner),
):
    cat = db.query(Category).filter(Category.id == cat_id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="Category not found")
    for k, v in update_data.model_dump(exclude_unset=True).items():
        setattr(cat, k, v)
    db.commit()
    db.refresh(cat)
    return cat


@router.delete("/{cat_id}")
def delete_category(
    cat_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_owner),
):
    cat = db.query(Category).filter(Category.id == cat_id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="Category not found")
    db.delete(cat)
    db.commit()
    return {"message": "Category deleted"}
