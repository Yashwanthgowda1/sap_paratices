"""
conftest.py - Centralized pytest fixtures
Handles: base URL, session, token, dynamic booking lifecycle
"""
import pytest
import requests
import os
import sys
from dotenv import load_dotenv

# Allow imports from project root
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

load_dotenv()

# ── Base configuration ──────────────────────────────────────────────────────

@pytest.fixture(scope="session")
def base_url():
    """Reads BASE_URL from .env once per session."""
    url = os.getenv("BASE_URL", "https://restful-booker.herokuapp.com")
    return url.rstrip("/")


@pytest.fixture(scope="session")
def credentials():
    return {
        "username": os.getenv("USERNAME", "admin"),
        "password": os.getenv("PASSWORD", "password123"),
    }


# ── Auth token ───────────────────────────────────────────────────────────────

@pytest.fixture(scope="session")
def auth_token(base_url, credentials):
    """Generates a Bearer token once per test session."""
    response = requests.post(
        f"{base_url}/auth",
        json=credentials,
        headers={"Content-Type": "application/json"},
        timeout=15,
    )
    assert response.status_code == 200, f"Auth failed: {response.text}"
    token = response.json().get("token")
    assert token, "Token not found in auth response"
    return token


# ── Session management ───────────────────────────────────────────────────────

@pytest.fixture(scope="session")
def api_session(base_url, auth_token):
    """
    Authenticated requests.Session reused across the whole test session.
    Sets default headers and auth cookie so every request is pre-authorised.
    """
    session = requests.Session()
    session.headers.update({
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Cookie": f"token={auth_token}",
    })
    session.base_url = base_url  # custom attr for convenience
    yield session
    session.close()


@pytest.fixture(scope="function")
def fresh_session(base_url, auth_token):
    """
    Fresh session per test function — use when tests must not share state.
    """
    session = requests.Session()
    session.headers.update({
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Cookie": f"token={auth_token}",
    })
    yield session
    session.close()


# ── Dynamic booking fixtures ─────────────────────────────────────────────────

def _booking_payload(**overrides):
    """Returns a valid booking payload with optional field overrides."""
    payload = {
        "firstname": "John",
        "lastname":  "Doe",
        "totalprice": 150,
        "depositpaid": True,
        "bookingdates": {
            "checkin":  "2025-01-10",
            "checkout": "2025-01-15",
        },
        "additionalneeds": "Breakfast",
    }
    payload.update(overrides)
    return payload


@pytest.fixture(scope="function")
def sample_payload():
    """Plain booking dict — no network call, use when you create manually."""
    return _booking_payload()


@pytest.fixture(scope="function")
def created_booking(api_session, base_url):
    """
    Creates a booking before the test, yields (id, data), then deletes it.
    Guarantees clean state without polluting the remote dataset.
    """
    payload = _booking_payload()
    resp = api_session.post(f"{base_url}/booking", json=payload)
    assert resp.status_code == 200, f"Setup booking creation failed: {resp.text}"

    data = resp.json()
    booking_id = data["bookingid"]

    yield {"id": booking_id, "data": data["booking"]}

    # teardown: delete the created booking
    api_session.delete(f"{base_url}/booking/{booking_id}")


@pytest.fixture(scope="module")
def module_booking(api_session, base_url):
    """
    Module-scoped booking — created once, shared by all tests in the module.
    """
    payload = _booking_payload(firstname="Module", lastname="Fixture")
    resp = api_session.post(f"{base_url}/booking", json=payload)
    assert resp.status_code == 200

    data = resp.json()
    booking_id = data["bookingid"]

    yield {"id": booking_id, "data": data["booking"]}

    api_session.delete(f"{base_url}/booking/{booking_id}")
