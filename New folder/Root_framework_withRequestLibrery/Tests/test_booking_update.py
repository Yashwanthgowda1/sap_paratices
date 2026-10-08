"""
test_booking_update.py - PUT /booking/{id}  and  PATCH /booking/{id}
Covers: full update, partial update, auth enforcement, field persistence
"""
import pytest
from .base_test import BaseTest


FULL_UPDATE_PAYLOAD = {
    "firstname":  "Updated",
    "lastname":   "User",
    "totalprice": 250,
    "depositpaid": False,
    "bookingdates": {
        "checkin":  "2026-01-01",
        "checkout": "2026-01-07",
    },
    "additionalneeds": "Dinner",
}


class TestPutBooking(BaseTest):
    """PUT /booking/{id} — full replacement."""

    def test_put_booking_returns_200(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.put(
            f"{base_url}/booking/{bid}", json=FULL_UPDATE_PAYLOAD
        )
        self.assert_ok(resp)

    def test_put_booking_updates_all_fields(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = api_session.put(
            f"{base_url}/booking/{bid}", json=FULL_UPDATE_PAYLOAD
        )
        self.assert_ok(resp)
        updated = resp.json()
        self.assert_booking_matches_payload(updated, FULL_UPDATE_PAYLOAD)

    def test_put_booking_persists_after_get(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        api_session.put(f"{base_url}/booking/{bid}", json=FULL_UPDATE_PAYLOAD)
        get_resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_ok(get_resp)
        self.assert_booking_matches_payload(get_resp.json(), FULL_UPDATE_PAYLOAD)

    def test_put_booking_response_has_required_fields(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = api_session.put(
            f"{base_url}/booking/{bid}", json=FULL_UPDATE_PAYLOAD
        )
        self.assert_booking_fields(resp.json())

    def test_put_booking_without_auth_returns_403(
        self, base_url, created_booking
    ):
        """PUT without auth cookie must be rejected."""
        import requests as req
        bid = created_booking["id"]
        resp = req.put(
            f"{base_url}/booking/{bid}",
            json=FULL_UPDATE_PAYLOAD,
            headers={"Content-Type": "application/json"},
            timeout=15,
        )
        assert resp.status_code in (403, 401), (
            f"Expected 401/403 without auth, got {resp.status_code}"
        )

    def test_put_nonexistent_booking_returns_404_or_405(
        self, api_session, base_url
    ):
        resp = api_session.put(
            f"{base_url}/booking/999999999", json=FULL_UPDATE_PAYLOAD
        )
        assert resp.status_code in (404, 405), (
            f"Expected 404/405, got {resp.status_code}"
        )

    @pytest.mark.parametrize("price", [0, 1, 9999])
    def test_put_booking_various_prices(
        self, api_session, base_url, created_booking, price
    ):
        bid     = created_booking["id"]
        payload = {**FULL_UPDATE_PAYLOAD, "totalprice": price}
        resp    = api_session.put(f"{base_url}/booking/{bid}", json=payload)
        self.assert_ok(resp)
        assert resp.json()["totalprice"] == price

    def test_put_booking_response_time(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = api_session.put(f"{base_url}/booking/{bid}", json=FULL_UPDATE_PAYLOAD)
        self.assert_response_time(resp, max_ms=5000)


class TestPatchBooking(BaseTest):
    """PATCH /booking/{id} — partial update."""

    def test_patch_firstname_only(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}", json={"firstname": "Patched"}
        )
        self.assert_ok(resp)
        assert resp.json()["firstname"] == "Patched"

    def test_patch_lastname_only(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}", json={"lastname": "PatchedLast"}
        )
        self.assert_ok(resp)
        assert resp.json()["lastname"] == "PatchedLast"

    def test_patch_totalprice_only(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}", json={"totalprice": 777}
        )
        self.assert_ok(resp)
        assert resp.json()["totalprice"] == 777

    def test_patch_preserves_untouched_fields(
        self, api_session, base_url, created_booking
    ):
        """Patching firstname should not change lastname."""
        bid      = created_booking["id"]
        original = api_session.get(f"{base_url}/booking/{bid}").json()
        api_session.patch(f"{base_url}/booking/{bid}", json={"firstname": "OnlyFirst"})
        updated  = api_session.get(f"{base_url}/booking/{bid}").json()
        assert updated["lastname"]    == original["lastname"],    "lastname changed unexpectedly"
        assert updated["totalprice"]  == original["totalprice"],  "totalprice changed unexpectedly"
        assert updated["depositpaid"] == original["depositpaid"], "depositpaid changed unexpectedly"

    def test_patch_bookingdates_checkin(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}",
            json={"bookingdates": {"checkin": "2026-03-01", "checkout": "2026-03-10"}},
        )
        self.assert_ok(resp)
        dates = resp.json()["bookingdates"]
        assert dates["checkin"]  == "2026-03-01"
        assert dates["checkout"] == "2026-03-10"

    def test_patch_without_auth_returns_403(
        self, base_url, created_booking
    ):
        import requests as req
        bid  = created_booking["id"]
        resp = req.patch(
            f"{base_url}/booking/{bid}",
            json={"firstname": "Hacker"},
            headers={"Content-Type": "application/json"},
            timeout=15,
        )
        assert resp.status_code in (401, 403), (
            f"Expected 401/403 without auth, got {resp.status_code}"
        )

    def test_patch_persists_after_get(self, api_session, base_url, created_booking):
        bid = created_booking["id"]
        api_session.patch(f"{base_url}/booking/{bid}", json={"totalprice": 321})
        get_resp = api_session.get(f"{base_url}/booking/{bid}")
        assert get_resp.json()["totalprice"] == 321

    def test_patch_additionalneeds(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}",
            json={"additionalneeds": "Spa access"},
        )
        self.assert_ok(resp)
        assert resp.json().get("additionalneeds") == "Spa access"

    def test_patch_response_time(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}", json={"firstname": "Fast"}
        )
        self.assert_response_time(resp, max_ms=5000)
