import sqlite3
import os

DB_PATH = "Sqllite/insurance.db"
SCHEMA_PATH = "Sqllite/schema.sql"


def create_database():
    if os.path.exists(DB_PATH):
        print(f"[INFO] Database '{DB_PATH}' already exists. Skipping creation.")
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        verify_tables(cursor)
        conn.close()
        return

    with open(SCHEMA_PATH, "r") as f:
        schema = f.read()

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    try:
        cursor.executescript(schema)
        conn.commit()
        print(f"[SUCCESS] Database '{DB_PATH}' created successfully.")
        verify_tables(cursor)
    except Exception as e:
        print(f"[ERROR] Failed to create database: {e}")
    finally:
        conn.close()


def verify_tables(cursor):
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
    tables = cursor.fetchall()
    print(f"\n[INFO] {len(tables)} tables created:")
    for (table,) in tables:
        cursor.execute(f"PRAGMA table_info({table});")
         
        columns = cursor.fetchall()
        col_names = [col[1] for col in columns] 

        print(f"  - {table:<30} ({len(columns)} columns)")
        print(f"columns: {col_names}")

if __name__ == "__main__":
    create_database()
