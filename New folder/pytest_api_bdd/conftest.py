"""
conftest.py  — the HEART of a pytest framework
================================================

Rules:
  1. Every fixture here is available to ALL tests in this project (no import needed).
  2. Scope controls how often a fixture is created:
       - "session"  → created ONCE per entire test run  (fastest — for token, logged-in client)
       - "module"   → created ONCE per test file
       - "function" → created for EVERY single test      (default — safe but slowest)
  3. yield  fixtures run teardown code after the 'yield' line automatically.
"""

import sys
from pathlib import Path
import pytest

# Make sure Python can always find our local packages regardless of CWD
sys.path.insert(0, str(Path(__file__).resolve().parent))

from client.api_client import APIClient
from config.settings import Config
from utils.logger import get_logger
from utils.data_loader import load_json, load_excel, load_properties

# conftest.py is auto-executed by pytest at collection time (not imported by tests).
# Module-level code here runs ONCE before the first test — safe for logger init.
logger = get_logger("conftest")


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 1 — bare client (no auth token, scope=session)
#
#  Use when: you want to call public endpoints or the /auth endpoint itself.
#  The session scope means this object is created ONCE and shared by all tests.
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture(scope="session")
def client() -> APIClient:
    logger.info("Creating unauthenticated APIClient (session scope)")
    api = APIClient(base_url=Config.BASE_URL)
    yield api                     # <── tests run here
    logger.info("Teardown: closing session for unauthenticated client")
    api.close()


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 2 — auth token (scope=session)
#
#  Calls /auth once for the whole run.  All tests that need a token share it.
#  If the token fetch fails, pytest will mark dependent tests as ERROR (not FAIL).
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture(scope="session")
def auth_token(client) -> str:
    logger.info("Fetching auth token (session scope)")
    response = client.post(
        "/auth",
        payload={"username": Config.USERNAME, "password": Config.PASSWORD},
    )
    assert response.status_code == 200, f"Auth failed: {response.text}"
    token = response.json().get("token")
    assert token, "Token missing from /auth response"
    logger.info(f"Token obtained: {token}")
    return token


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 3 — authenticated client (scope=session)
#
#  This is the fixture you will use in 90 % of your tests.
#  It injects the token into the shared session once.
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture(scope="session")
def auth_client(auth_token) -> APIClient:
    logger.info("Creating authenticated APIClient (session scope)")
    api = APIClient(base_url=Config.BASE_URL, token=auth_token)
    yield api
    logger.info("Teardown: closing session for authenticated client")
    api.close()


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 4 — fresh client per test (scope=function)
#
#  Use when: you need a completely clean session per test (e.g., testing logout,
#  testing expired tokens, or any test that mutates session state).
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture(scope="function")
def fresh_client() -> APIClient:
    logger.info("Creating fresh APIClient (function scope)")
    api = APIClient(base_url=Config.BASE_URL)
    yield api
    logger.info("Teardown: closing fresh client")
    api.close()


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 5 — booking payload loaded from JSON file (scope=function)
#
#  Data lives in resource/test_data/booking_data.json
#  To use a different record: override this fixture in your test file.
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture
def booking_payload() -> dict:
    return load_json("booking_data.json", key="valid_booking")


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 5b — booking payload loaded from Excel (scope=function)
#
#  resource/test_data/bookings.xlsx  →  sheet "CreateBooking"  →  row 0
#  Change row= to pick a different test record from the sheet.
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture
def booking_payload_excel() -> dict:
    row = load_excel("bookings.xlsx", sheet="CreateBooking", row=0)
    # Excel stores flat columns — rebuild the nested bookingdates dict the API expects
    return {
        "firstname":      row["firstname"],
        "lastname":       row["lastname"],
        "totalprice":     int(row["totalprice"]),
        "depositpaid":    bool(row["depositpaid"]),
        "bookingdates": {
            "checkin":  row["checkin"],
            "checkout": row["checkout"],
        },
        "additionalneeds": row.get("additionalneeds", ""),
    }


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 5c — config values from .properties file (scope=session)
#
#  resource/test_data/config.properties
#  Returns the full dict — tests read what they need.
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture(scope="session")
def config_props() -> dict:
    return load_properties("config.properties")


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE 6 — created booking id  (scope=function)
#
#  Creates a booking BEFORE the test and deletes it AFTER.
#  This is the "setup / teardown" pattern in pytest.
# ─────────────────────────────────────────────────────────────────────────────
@pytest.fixture
def created_booking_id(auth_client, booking_payload) -> int:
    # --- SETUP: create a booking ---
    response = auth_client.post("/booking", payload=booking_payload)
    assert response.status_code == 200
    booking_id = response.json()["bookingid"]
    logger.info(f"Setup: created booking id={booking_id}")

    yield booking_id              # <── test receives the id here

    # --- TEARDOWN: delete the booking ---
    logger.info(f"Teardown: deleting booking id={booking_id}")
    auth_client.delete(f"/booking/{booking_id}")
