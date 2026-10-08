from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, joinedload
from app.database import get_db
from app.models.product import Product
from app.models.barcode_log import BarcodeLog
from app.core.deps import get_current_user
from app.models.user import User

router = APIRouter()


@router.get("/scan/{barcode}")
def scan_barcode(
    barcode: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    product = (
        db.query(Product)
        .options(joinedload(Product.category), joinedload(Product.supplier))
        .filter(Product.barcode == barcode)
        .first()
    )

    log = BarcodeLog(
        barcode=barcode,
        product_id=product.id if product else None,
        scanned_by_id=current_user.id,
        found=product is not None,
    )
    db.add(log)
    db.commit()

    if not product:
        return {
            "found": False,
            "barcode": barcode,
            "message": "Product not found. Add a new product with this barcode.",
        }

    return {
        "found": True,
        "barcode": barcode,
        "product": {
            "id": product.id,
            "name": product.name,
            "barcode": product.barcode,
            "selling_price": product.selling_price,
            "purchase_price": product.purchase_price,
            "stock_quantity": product.stock_quantity,
            "category": product.category.name if product.category else None,
            "brand": product.brand,
            "storage_location": product.storage_location,
            "image_url": product.image_url,
            "min_stock_level": product.min_stock_level,
            "is_available": product.stock_quantity > 0,
        },
    }
