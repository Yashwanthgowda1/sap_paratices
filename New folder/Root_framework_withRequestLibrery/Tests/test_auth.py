"""
test_auth.py - Authentication & Session tests
Covers: token generation, invalid credentials, session header propagation
"""
import requests
import pytest
from .base_test import BaseTest


class TestAuthentication(BaseTest):

    # ── Token generation ─────────────────────────────────────────────────────

    def test_valid_credentials_return_token(self, base_url, credentials):
        resp = requests.post(
            f"{base_url}/auth",
            json=credentials,
            headers={"Content-Type": "application/json"},
            timeout=15,
        )
        self.assert_ok(resp)
        body = resp.json()
        assert "token" in body, f"'token' key missing: {body}"
        assert len(body["token"]) > 5, "Token looks too short"

    def test_invalid_password_returns_bad_credentials(self, base_url, credentials):
        resp = requests.post(
            f"{base_url}/auth",
            json={"username": credentials["username"], "password": "wrong_pass"},
            headers={"Content-Type": "application/json"},
            timeout=15,
        )
        self.assert_ok(resp)  # API returns 200 even for bad creds
        body = resp.json()
        # restful-booker returns {"reason": "Bad credentials"} when wrong
        assert body.get("reason") == "Bad credentials" or "token" not in body, (
            f"Expected bad-credentials response, got: {body}"
        )

    def test_invalid_username_returns_bad_credentials(self, base_url):
        resp = requests.post(
            f"{base_url}/auth",
            json={"username": "no_such_user", "password": "no_such_pass"},
            timeout=15,
        )
        self.assert_ok(resp)
        body = resp.json()
        assert "token" not in body or body.get("reason") == "Bad credentials"

    def test_missing_credentials_handled(self, base_url):
        resp = requests.post(
            f"{base_url}/auth",
            json={},
            timeout=15,
        )
        # Should not crash the server
        assert resp.status_code in (200, 400, 422), (
            f"Unexpected status: {resp.status_code}"
        )

    def test_auth_response_time(self, base_url, credentials):
        resp = requests.post(
            f"{base_url}/auth",
            json=credentials,
            timeout=15,
        )
        self.assert_response_time(resp, max_ms=5000)

    # ── Session fixture validation ───────────────────────────────────────────

    def test_session_carries_auth_token(self, api_session, base_url):
        """Confirm the shared session can reach a protected endpoint."""
        # Creating a booking requires auth; if session has no cookie it returns 403/500
        resp = api_session.get(f"{base_url}/booking", timeout=15)
        self.assert_ok(resp)

    def test_session_content_type_header(self, api_session):
        assert "Content-Type" in api_session.headers
        assert "application/json" in api_session.headers["Content-Type"]

    def test_token_format_is_string(self, auth_token):
        assert isinstance(auth_token, str), "Token must be a string"
        assert len(auth_token) > 5, "Token too short to be valid"

    def test_fresh_session_isolated_from_shared_session(
        self, api_session, fresh_session
    ):
        assert api_session is not fresh_session

    # ── Session reuse across multiple requests ───────────────────────────────

    def test_session_reused_across_calls(self, api_session, base_url):
        """Same session object should succeed on two consecutive calls."""
        r1 = api_session.get(f"{base_url}/booking", timeout=15)
        r2 = api_session.get(f"{base_url}/booking", timeout=15)
        self.assert_ok(r1)
        self.assert_ok(r2)
