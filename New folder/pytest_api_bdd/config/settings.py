import os
from pathlib import Path
from dotenv import load_dotenv

# Always resolve .env from project root regardless of where pytest is run from
ROOT_DIR = Path(__file__).resolve().parent.parent
load_dotenv(dotenv_path=ROOT_DIR / ".env", override=True)


class Config:
    BASE_URL: str = os.getenv("BASE_URL", "https://restful-booker.herokuapp.com")
    USERNAME: str = os.getenv("USERNAME", "admin")
    PASSWORD: str = os.getenv("PASSWORD", "password123")
    TIMEOUT: int = int(os.getenv("TIMEOUT", "30"))
