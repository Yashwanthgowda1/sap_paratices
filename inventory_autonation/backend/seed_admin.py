"""
Run this script once to create the default owner admin account.
Usage: python seed_admin.py (from the backend/ directory with venv active)
"""
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app.database import SessionLocal
from app.models.user import User, UserRole
from app.core.security import get_password_hash

db = SessionLocal()

existing = db.query(User).filter(User.username == "admin").first()
if existing:
    print("Admin account already exists.")
else:
    admin = User(
        username="admin",
        email="admin@shop.com",
        full_name="Admin Owner",
        role=UserRole.owner,
        password_hash=get_password_hash("admin123"),
        is_active=True,
    )
    db.add(admin)
    db.commit()
    print("[OK] Admin account created successfully!")
    print("  Username: admin")
    print("  Password: admin123")
    print("  Role:     owner")
    print("\n[!] Change the password after first login!")

db.close()
