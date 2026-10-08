from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base
from app.config import settings

# Import all models to register them with SQLAlchemy metadata
from app.models import User, UserRole, Product, Category, Supplier  # noqa: F401
from app.models import StockTransaction, Sale, SaleItem, BarcodeLog  # noqa: F401

from app.api.v1 import auth, users, products, categories, suppliers, stock, barcode, sales, reports


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create all tables on startup (idempotent — safe to call every cold start)
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title="Inventory Management API",
    description="ShopSync — Complete inventory management system for retail shops",
    version="1.0.0",
    lifespan=lifespan,
)

ALLOWED_ORIGINS = [o.strip() for o in settings.CORS_ORIGINS.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(products.router, prefix="/api/v1/products", tags=["Products"])
app.include_router(categories.router, prefix="/api/v1/categories", tags=["Categories"])
app.include_router(suppliers.router, prefix="/api/v1/suppliers", tags=["Suppliers"])
app.include_router(stock.router, prefix="/api/v1/stock", tags=["Stock"])
app.include_router(barcode.router, prefix="/api/v1/barcode", tags=["Barcode"])
app.include_router(sales.router, prefix="/api/v1/sales", tags=["Sales"])
app.include_router(reports.router, prefix="/api/v1/reports", tags=["Reports"])


@app.get("/")
def root():
    return {"message": "ShopSync Inventory API", "version": "1.0.0"}


@app.get("/health")
def health():
    return {"status": "healthy"}
