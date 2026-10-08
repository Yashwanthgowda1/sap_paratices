import json
from pathlib import Path

_DIR = Path(__file__).resolve().parent / "json_payloads"


def load(filename: str) -> dict:
    with open(_DIR / filename) as f:
        return json.load(f)


class TestData:
    USERS    = load("users.json")
    CONTENT  = load("content.json")

    VALID_USER    = USERS["valid_user"]
    PREMIUM_USER  = USERS["premium_user"]
    INVALID_USER  = USERS["invalid_user"]

    MOVIE         = CONTENT["movie"]
    SERIES        = CONTENT["series"]
    FREE_CONTENT  = CONTENT["free_content"]
    SPORTS        = CONTENT["sports"]
    SEARCH_VALID  = CONTENT["search_keywords"]["valid"]
    SEARCH_NONE   = CONTENT["search_keywords"]["no_results"]
