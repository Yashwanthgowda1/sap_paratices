import json
import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

_ROOT = Path(__file__).resolve().parent.parent
_CONFIG_FILE = _ROOT / "config" / "config.json"


def _load_config() -> dict:
    with open(_CONFIG_FILE) as f:
        return json.load(f)


_cfg = _load_config()
_ENV = os.getenv("ENV", "staging")


class Config:
    # ── Environment ───────────────────────────────────────────────────────────
    ENV: str = _ENV

    # ── URLs ──────────────────────────────────────────────────────────────────
    BASE_URL: str = os.getenv("BASE_URL", _cfg["environments"][_ENV]["base_url"])
    API_BASE_URL: str = os.getenv("API_BASE_URL", _cfg["environments"][_ENV]["api_base_url"])

    # ── Browser ───────────────────────────────────────────────────────────────
    BROWSER: str = os.getenv("BROWSER", _cfg["browser"]["default"])
    HEADLESS: bool = os.getenv("HEADLESS", "false").lower() == "true"

    # ── Timeouts ──────────────────────────────────────────────────────────────
    IMPLICIT_WAIT: int = int(_cfg["timeouts"]["implicit_wait"])
    EXPLICIT_WAIT: int = int(_cfg["timeouts"]["explicit_wait"])
    PAGE_LOAD_TIMEOUT: int = int(_cfg["timeouts"]["page_load"])

    # ── Credentials ───────────────────────────────────────────────────────────
    VALID_EMAIL: str = os.getenv("VALID_EMAIL", _cfg["test_data"]["valid_user"]["email"])
    VALID_PASSWORD: str = os.getenv("VALID_PASSWORD", _cfg["test_data"]["valid_user"]["password"])
    PREMIUM_EMAIL: str = os.getenv("PREMIUM_EMAIL", _cfg["test_data"]["premium_user"]["email"])
    PREMIUM_PASSWORD: str = os.getenv("PREMIUM_PASSWORD", _cfg["test_data"]["premium_user"]["password"])
    INVALID_EMAIL: str = os.getenv("INVALID_EMAIL", _cfg["test_data"]["invalid_user"]["email"])
    INVALID_PASSWORD: str = os.getenv("INVALID_PASSWORD", _cfg["test_data"]["invalid_user"]["password"])

    # ── Content ───────────────────────────────────────────────────────────────
    MOVIE_TITLE: str = _cfg["content"]["movie_title"]
    SERIES_TITLE: str = _cfg["content"]["series_title"]
    LIVE_CHANNEL: str = _cfg["content"]["live_channel"]
    SEARCH_KEYWORD: str = _cfg["content"]["search_keyword"]
    FREE_CONTENT_ID: str = _cfg["content"]["free_content_id"]
    PREMIUM_CONTENT_ID: str = _cfg["content"]["premium_content_id"]

    # ── Paths ─────────────────────────────────────────────────────────────────
    ROOT_DIR: Path = _ROOT
    REPORTS_DIR: Path = _ROOT / "reports"
    SCREENSHOTS_DIR: Path = _ROOT / "reports" / "screenshots"
    LOGS_DIR: Path = _ROOT / "logs"
    TEST_DATA_DIR: Path = _ROOT / "test_data"
    SCHEMAS_DIR: Path = _ROOT / "schemas"
