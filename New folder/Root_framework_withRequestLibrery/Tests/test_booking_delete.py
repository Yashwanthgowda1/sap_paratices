"""
test_booking_delete.py - DELETE /booking/{id}
Covers: auth delete, unauthenticated rejection, idempotency, cleanup verification
"""
import requests as req
import pytest
from .base_test import BaseTest


class TestDeleteBooking(BaseTest):

    # ── Authenticated delete ─────────────────────────────────────────────────

    def test_delete_booking_returns_201(self, api_session, base_url, created_booking):
        """Restful-booker returns 201 Created on successful delete (API quirk)."""
        bid  = created_booking["id"]
        resp = api_session.delete(f"{base_url}/booking/{bid}")
        # restful-booker uses 201 for DELETE success
        assert resp.status_code in (200, 201), (
            f"Expected 200/201 on delete, got {resp.status_code}"
        )

    def test_deleted_booking_no_longer_accessible(
        self, api_session, base_url
    ):
        """Create, delete, then confirm GET returns 404."""
        # Create a fresh booking specifically for this test
        payload = {
            "firstname":  "ToDelete",
            "lastname":   "Me",
            "totalprice": 10,
            "depositpaid": False,
            "bookingdates": {"checkin": "2025-11-01", "checkout": "2025-11-02"},
        }
        create_resp = api_session.post(f"{base_url}/booking", json=payload)
        self.assert_ok(create_resp)
        bid = create_resp.json()["bookingid"]

        del_resp = api_session.delete(f"{base_url}/booking/{bid}")
        assert del_resp.status_code in (200, 201)

        get_resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_not_found(get_resp)

    def test_delete_booking_removed_from_list(
        self, api_session, base_url
    ):
        """After delete, ID must not appear in GET /booking."""
        payload = {
            "firstname":  "ListDelete",
            "lastname":   "Test",
            "totalprice": 50,
            "depositpaid": True,
            "bookingdates": {"checkin": "2025-12-01", "checkout": "2025-12-02"},
        }
        create_resp = api_session.post(f"{base_url}/booking", json=payload)
        self.assert_ok(create_resp)
        bid = create_resp.json()["bookingid"]

        api_session.delete(f"{base_url}/booking/{bid}")

        list_resp = api_session.get(f"{base_url}/booking")
        self.assert_ok(list_resp)
        ids = [b["bookingid"] for b in list_resp.json()]
        assert bid not in ids, f"Deleted booking {bid} still in list"

    def test_delete_response_time(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.delete(f"{base_url}/booking/{bid}")
        self.assert_response_time(resp, max_ms=5000)

    # ── Unauthenticated delete ───────────────────────────────────────────────

    def test_delete_without_auth_returns_403(
        self, base_url, created_booking
    ):
        """DELETE without auth token must be rejected."""
        bid  = created_booking["id"]
        resp = req.delete(
            f"{base_url}/booking/{bid}",
            headers={"Content-Type": "application/json"},
            timeout=15,
        )
        assert resp.status_code in (401, 403), (
            f"Expected 401/403 without auth, got {resp.status_code}"
        )

    def test_delete_with_wrong_token_returns_403(
        self, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = req.delete(
            f"{base_url}/booking/{bid}",
            headers={
                "Content-Type": "application/json",
                "Cookie": "token=completely_invalid_token",
            },
            timeout=15,
        )
        assert resp.status_code in (401, 403), (
            f"Expected 401/403 with bad token, got {resp.status_code}"
        )

    # ── Idempotency & edge cases ─────────────────────────────────────────────

    def test_delete_nonexistent_booking_returns_404_or_405(
        self, api_session, base_url
    ):
        resp = api_session.delete(f"{base_url}/booking/999999999")
        assert resp.status_code in (404, 405), (
            f"Expected 404/405, got {resp.status_code}"
        )

    def test_double_delete_second_call_returns_error(
        self, api_session, base_url
    ):
        """Deleting the same ID twice: second call should return 4xx."""
        payload = {
            "firstname":  "DoubleDelete",
            "lastname":   "Test",
            "totalprice": 1,
            "depositpaid": False,
            "bookingdates": {"checkin": "2026-02-01", "checkout": "2026-02-02"},
        }
        create_resp = api_session.post(f"{base_url}/booking", json=payload)
        bid = create_resp.json()["bookingid"]

        first  = api_session.delete(f"{base_url}/booking/{bid}")
        second = api_session.delete(f"{base_url}/booking/{bid}")

        assert first.status_code  in (200, 201)
        assert second.status_code in (404, 405), (
            f"Second delete should be 404/405, got {second.status_code}"
        )
