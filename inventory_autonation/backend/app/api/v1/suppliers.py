from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app.models.supplier import Supplier
from app.schemas.supplier import SupplierCreate, SupplierUpdate, SupplierResponse
from app.core.deps import get_current_user, require_owner
from app.models.user import User

router = APIRouter()


@router.get("/", response_model=List[SupplierResponse])
def list_suppliers(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return db.query(Supplier).all()


@router.get("/{sup_id}", response_model=SupplierResponse)
def get_supplier(
    sup_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    sup = db.query(Supplier).filter(Supplier.id == sup_id).first()
    if not sup:
        raise HTTPException(status_code=404, detail="Supplier not found")
    return sup


@router.post("/", response_model=SupplierResponse)
def create_supplier(
    sup_data: SupplierCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    sup = Supplier(**sup_data.model_dump())
    db.add(sup)
    db.commit()
    db.refresh(sup)
    return sup


@router.put("/{sup_id}", response_model=SupplierResponse)
def update_supplier(
    sup_id: int,
    update_data: SupplierUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    sup = db.query(Supplier).filter(Supplier.id == sup_id).first()
    if not sup:
        raise HTTPException(status_code=404, detail="Supplier not found")
    for k, v in update_data.model_dump(exclude_unset=True).items():
        setattr(sup, k, v)
    db.commit()
    db.refresh(sup)
    return sup


@router.delete("/{sup_id}")
def delete_supplier(
    sup_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_owner),
):
    sup = db.query(Supplier).filter(Supplier.id == sup_id).first()
    if not sup:
        raise HTTPException(status_code=404, detail="Supplier not found")
    db.delete(sup)
    db.commit()
    return {"message": "Supplier deleted"}
