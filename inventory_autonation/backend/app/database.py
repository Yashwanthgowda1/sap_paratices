from sqlalchemy import create_engine
from sqlalchemy.pool import NullPool
from sqlalchemy.orm import sessionmaker, DeclarativeBase
from app.config import settings

# NullPool is required for serverless environments (Vercel) to avoid
# connection leaks — each function invocation gets a fresh connection.
engine = create_engine(
    settings.DATABASE_URL,
    poolclass=NullPool,
    echo=False,
    connect_args={"sslmode": "require"} if "neon.tech" in settings.DATABASE_URL else {},
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    pass


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
