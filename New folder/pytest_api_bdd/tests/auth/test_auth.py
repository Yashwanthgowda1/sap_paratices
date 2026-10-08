"""
test_auth.py
============
Tests for the /auth endpoint.

Key points:
  - Uses the 'client' fixture (unauthenticated, session scope) from conftest.py.
  - Does NOT use 'auth_client' because this IS the test that proves auth works.
"""

import pytest


class TestAuth:
    """Group related tests in a class — no __init__ needed."""

    def test_valid_credentials_returns_token(self, client):
        """Happy path: valid creds → HTTP 200 with a token string."""
        response = client.post(
            "/auth",
            payload={"username": "admin", "password": "password123"},
        )
        assert response.status_code == 200
        body = response.json()
        assert "token" in body, f"Expected 'token' key, got: {body}"
        assert isinstance(body["token"], str)
        assert len(body["token"]) > 0

    def test_invalid_password_returns_bad_credentials(self, client):
        """Sad path: wrong password → body contains 'Bad credentials'."""
        response = client.post(
            "/auth",
            payload={"username": "admin", "password": "wrong_password"},
        )
        assert response.status_code == 200          # API returns 200 even on bad creds
        body = response.json()
        assert body.get("reason") == "Bad credentials"

    def test_missing_username_field(self, client):
        """Edge case: missing username field."""
        response = client.post(
            "/auth",
            payload={"password": "password123"},    # no username
        )
        assert response.status_code == 200
        assert "reason" in response.json()

    @pytest.mark.parametrize("username, password", [
        ("",      "password123"),   # empty username
        ("admin", ""),              # empty password
        ("",      ""),              # both empty
    ])
    def test_empty_credentials_rejected(self, client, username, password):
        """Parametrize lets you run the same test with different inputs."""
        response = client.post(
            "/auth",
            payload={"username": username, "password": password},
        )
        body = response.json()
        # The API should not return a valid token for empty creds
        assert "token" not in body or body.get("reason") is not None
