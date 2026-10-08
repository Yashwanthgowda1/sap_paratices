# ShopSync — Inventory Management System

A complete full-stack inventory management system for small-scale retail shops. Built with FastAPI, PostgreSQL, and React.js with a professional dark theme UI.

---

## Project Structure

```
inventory_autonation/
├── backend/                    # FastAPI backend
│   ├── app/
│   │   ├── main.py             # FastAPI application entry point
│   │   ├── config.py           # Settings / environment config
│   │   ├── database.py         # SQLAlchemy engine & session
│   │   ├── models/             # SQLAlchemy ORM models
│   │   ├── schemas/            # Pydantic schemas
│   │   ├── core/               # Security (JWT, bcrypt), dependencies
│   │   └── api/v1/             # API route handlers
│   ├── alembic/                # Database migrations
│   ├── alembic.ini
│   ├── requirements.txt
│   └── .env                    # Environment variables
└── frontend/                   # React frontend
    ├── public/
    ├── src/
    │   ├── App.js              # Router + protected routes
    │   ├── index.css           # Global dark theme stylesheet
    │   ├── context/            # AuthContext
    │   ├── services/api.js     # Axios + all API calls
    │   ├── components/Layout/  # Sidebar, Header, Layout
    │   └── pages/              # Login, Dashboard, Products, etc.
    ├── package.json
    └── .env
```

---

## Prerequisites

- **Python** 3.10+
- **Node.js** 18+ and npm
- **PostgreSQL** 14+

---

## 1. Database Setup

```bash
# Start PostgreSQL and create database
psql -U postgres
CREATE DATABASE inventory_db;
\q
```

---

## 2. Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Copy .env.example to .env and configure
cp .env.example .env
```

Edit `.env`:
```
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/inventory_db
SECRET_KEY=your-random-32-char-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
```

### Run Database Migrations

**Option A — Automatic (development, tables created on startup):**
The app auto-creates tables on first run via `Base.metadata.create_all()`.

**Option B — Alembic (recommended for production):**
```bash
# Generate initial migration
alembic revision --autogenerate -m "initial"

# Apply migration
alembic upgrade head
```

### Create Initial Owner Account

After starting the server for the first time, run this Python snippet to create the default admin account:

```bash
python -c "
from app.database import SessionLocal
from app.models.user import User, UserRole
from app.core.security import get_password_hash
db = SessionLocal()
u = User(username='admin', email='admin@shop.com', full_name='Admin Owner',
         role=UserRole.owner, password_hash=get_password_hash('admin123'))
db.add(u)
db.commit()
print('Admin created: admin / admin123')
db.close()
"
```

### Start the Backend Server

```bash
# From the backend/ directory with venv activated
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

API will be running at: **http://localhost:8000**
Swagger docs: **http://localhost:8000/docs**

---

## 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env
# Default: REACT_APP_API_URL=http://localhost:8000

# Start development server
npm start
```

Frontend will be running at: **http://localhost:3000**

---

## 4. Login

Open http://localhost:3000 and log in with:
- **Username:** `admin`
- **Password:** `admin123`

---

## Features

### Authentication & Roles
- JWT token-based login
- Two roles: **Owner** (full access) and **Manager** (limited access)
- Owner-only: delete products, manage users

### Dashboard
- Stats cards: total products, today's sales, month's sales, stock value, low/out-of-stock counts
- 7-day sales bar chart
- Low stock alerts
- Recent transactions

### Barcode Scanner
- Camera-based real-time scanning via `html5-qrcode`
- Manual barcode entry (also works with physical USB/Bluetooth barcode scanners)
- Product lookup: shows name, price, stock, availability
- "Add to Sale" button if product found
- "Add New Product" button if barcode not in system
- All scans are logged in `barcode_logs` table

### Product Management
- Full CRUD with modal form
- Fields: name, barcode, category, brand, purchase/selling price, stock qty, expiry date, supplier, image URL, storage location, description, min stock level
- Search by name or barcode
- Filter by category or stock status (low/out)
- Pagination

### Stock Management
- Add stock, reduce stock, mark as damaged, or adjust to exact quantity
- Full transaction history with audit trail
- Real-time current stock overview per product

### Sales / POS
- Scan barcode to add items to cart
- Quantity controls (respects available stock)
- Discount field
- Payment method: Cash, Card, UPI, Other
- Auto-generates invoice number (INV-YYYYMMDD-XXXXXX)
- One-click checkout: reduces stock, creates sale + sale items + stock transaction records
- Invoice modal with print support

### Reports
- **Sales Report**: Revenue, order count, discounts for a date range; export CSV
- **Stock Report**: All products with stock value, status; export CSV
- **Product Sales**: Units sold, revenue, and profit per product; bar chart
- **Dashboard Stats**: Summary overview

### Supplier Management
- CRUD for suppliers: name, contact, email, address
- Linked to products

### User Management (Owner only)
- View all staff accounts
- Add, edit, disable/enable users
- Assign roles (owner/manager)

---

## API Endpoints

| Module      | Method | Endpoint                          | Description              |
|-------------|--------|-----------------------------------|--------------------------|
| Auth        | POST   | /api/v1/auth/login                | Login                    |
| Auth        | POST   | /api/v1/auth/register             | Register                 |
| Users       | GET    | /api/v1/users/                    | List users (owner)       |
| Users       | GET    | /api/v1/users/me                  | Current user             |
| Products    | GET    | /api/v1/products/                 | List products            |
| Products    | POST   | /api/v1/products/                 | Create product           |
| Products    | PUT    | /api/v1/products/{id}             | Update product           |
| Products    | DELETE | /api/v1/products/{id}             | Delete product (owner)   |
| Barcode     | GET    | /api/v1/barcode/scan/{barcode}    | Scan barcode             |
| Stock       | GET    | /api/v1/stock/                    | Transaction history      |
| Stock       | POST   | /api/v1/stock/                    | Record transaction       |
| Sales       | POST   | /api/v1/sales/                    | Create sale              |
| Sales       | GET    | /api/v1/sales/                    | List sales               |
| Reports     | GET    | /api/v1/reports/dashboard         | Dashboard stats          |
| Reports     | GET    | /api/v1/reports/sales             | Sales report             |
| Reports     | GET    | /api/v1/reports/stock             | Stock report             |
| Reports     | GET    | /api/v1/reports/product-sales     | Product-wise sales       |
| Reports     | GET    | /api/v1/reports/export/sales      | Export sales CSV         |
| Reports     | GET    | /api/v1/reports/export/stock      | Export stock CSV         |
| Categories  | GET    | /api/v1/categories/               | List categories          |
| Suppliers   | GET    | /api/v1/suppliers/                | List suppliers           |

Full interactive documentation available at: **http://localhost:8000/docs**

---

## Database Tables

| Table             | Description                          |
|-------------------|--------------------------------------|
| users             | Staff accounts with roles            |
| categories        | Product categories                   |
| suppliers         | Supplier information                 |
| products          | Product catalogue with pricing       |
| stock_transactions| Stock add/reduce/damage/adjust log   |
| sales             | Sale invoices                        |
| sale_items        | Line items per sale                  |
| barcode_logs      | Audit log of all barcode scans       |

---

## Tech Stack

| Layer      | Technology                                    |
|------------|-----------------------------------------------|
| Backend    | FastAPI 0.104, Python 3.10+                   |
| ORM        | SQLAlchemy 2.0, Alembic                       |
| Database   | PostgreSQL 14+                                |
| Auth       | JWT (python-jose), bcrypt (passlib)           |
| Frontend   | React 18, React Router 6                      |
| HTTP       | Axios                                         |
| Charts     | Recharts                                      |
| Barcode    | html5-qrcode                                  |
| Styling    | Custom CSS with dark theme variables          |

---

## Environment Variables

### Backend `.env`
```
DATABASE_URL=postgresql://postgres:password@localhost:5432/inventory_db
SECRET_KEY=your-32-char-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
```

### Frontend `.env`
```
REACT_APP_API_URL=http://localhost:8000
```

---

## Production Deployment Tips

1. Change `SECRET_KEY` to a strong random value: `openssl rand -hex 32`
2. Use `alembic upgrade head` for migrations (not `create_all`)
3. Serve the React build with nginx: `npm run build`
4. Use a production WSGI server: `gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker`
5. Set proper CORS origins in `main.py`
