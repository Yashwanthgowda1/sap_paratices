"""
test_booking.py
===============
Full CRUD tests for the /booking endpoint.

Fixture dependency chain (read bottom-up):
  created_booking_id
      └── auth_client  ←── auth_token  ←── client
      └── booking_payload

All fixtures come from conftest.py — no imports needed.
"""

import json
from pathlib import Path
import pytest


# ── Load test data from JSON file ────────────────────────────────────────────
DATA_FILE = Path(__file__).resolve().parent.parent.parent / "resource" / "test_data" / "booking_data.json"
with open(DATA_FILE) as f:
    TEST_DATA = json.load(f)


# ─────────────────────────────────────────────────────────────────────────────
#  GET tests
# ─────────────────────────────────────────────────────────────────────────────
class TestGetBooking:

    def test_get_all_bookings_returns_list(self, client):
        """GET /booking should return a list of booking IDs."""
        response = client.get("/booking")
        assert response.status_code == 200
        body = response.json()
        assert isinstance(body, list), f"Expected list, got {type(body)}"
        assert len(body) > 0, "Booking list is empty"

    def test_get_all_bookings_items_have_id(self, client):
        response = client.get("/booking")
        assert response.status_code == 200
        for item in response.json():
            assert "bookingid" in item

    def test_get_single_booking_by_id(self, created_booking_id, auth_client):
        """GET /booking/{id} returns the booking we just created."""
        response = auth_client.get(f"/booking/{created_booking_id}")
        assert response.status_code == 200
        body = response.json()
        assert body["firstname"] == "Yashwanth"
        assert body["lastname"] == "Gowda"

    def test_get_nonexistent_booking_returns_404(self, client):
        response = client.get("/booking/999999999")
        assert response.status_code == 404

    @pytest.mark.parametrize("firstname, lastname", [
        ("Yashwanth", "Gowda"),
        ("Jim",       "Brown"),
    ])
    def test_filter_bookings_by_name(self, client, firstname, lastname):
        """GET /booking?firstname=X&lastname=Y — parametrize covers multiple combos."""
        response = client.get(f"/booking?firstname={firstname}&lastname={lastname}")
        assert response.status_code == 200
        assert isinstance(response.json(), list)


# ─────────────────────────────────────────────────────────────────────────────
#  POST — Create booking
# ─────────────────────────────────────────────────────────────────────────────
class TestCreateBooking:

    def test_create_booking_returns_200(self, auth_client, booking_payload):
        response = auth_client.post("/booking", payload=booking_payload)
        assert response.status_code == 200

    def test_create_booking_response_has_id(self, auth_client, booking_payload):
        response = auth_client.post("/booking", payload=booking_payload)
        assert response.status_code == 200
        body = response.json()
        assert "bookingid" in body
        assert isinstance(body["bookingid"], int)

    def test_create_booking_response_mirrors_payload(self, auth_client, booking_payload):
        response = auth_client.post("/booking", payload=booking_payload)
        assert response.status_code == 200
        created = response.json()["booking"]
        assert created["firstname"] == booking_payload["firstname"]
        assert created["totalprice"] == booking_payload["totalprice"]
        assert created["depositpaid"] == booking_payload["depositpaid"]

    def test_create_booking_from_json_file(self, auth_client):
        """Load payload from JSON file — keeps test data out of test code."""
        payload = TEST_DATA["valid_booking"]
        response = auth_client.post("/booking", payload=payload)
        assert response.status_code == 200
        assert "bookingid" in response.json()


# ─────────────────────────────────────────────────────────────────────────────
#  PUT — Full update
# ─────────────────────────────────────────────────────────────────────────────
class TestUpdateBooking:

    def test_full_update_returns_200(self, auth_client, created_booking_id):
        """PUT /booking/{id} replaces the whole booking."""
        payload = TEST_DATA["updated_booking"]
        response = auth_client.put(f"/booking/{created_booking_id}", payload=payload)
        assert response.status_code == 200

    def test_full_update_persists_changes(self, auth_client, created_booking_id):
        payload = TEST_DATA["updated_booking"]
        auth_client.put(f"/booking/{created_booking_id}", payload=payload)

        # Verify change was saved by doing a GET
        get_response = auth_client.get(f"/booking/{created_booking_id}")
        assert get_response.status_code == 200
        body = get_response.json()
        assert body["firstname"] == payload["firstname"]
        assert body["totalprice"] == payload["totalprice"]


# ─────────────────────────────────────────────────────────────────────────────
#  PATCH — Partial update
# ─────────────────────────────────────────────────────────────────────────────
class TestPartialUpdateBooking:

    def test_patch_price_only(self, auth_client, created_booking_id):
        """PATCH /booking/{id} — only send the fields you want to change."""
        response = auth_client.patch(
            f"/booking/{created_booking_id}",
            payload={"totalprice": 9999},
        )
        assert response.status_code == 200
        assert response.json()["totalprice"] == 9999

    def test_patch_does_not_overwrite_other_fields(self, auth_client, created_booking_id):
        original = auth_client.get(f"/booking/{created_booking_id}").json()
        auth_client.patch(
            f"/booking/{created_booking_id}",
            payload={"totalprice": 1},
        )
        updated = auth_client.get(f"/booking/{created_booking_id}").json()
        # Only price should change — firstname must stay the same
        assert updated["firstname"] == original["firstname"]


# ─────────────────────────────────────────────────────────────────────────────
#  DELETE
# ─────────────────────────────────────────────────────────────────────────────
class TestDeleteBooking:

    def test_delete_booking_returns_201(self, auth_client, booking_payload):
        # Create a booking specifically for this delete test
        create_resp = auth_client.post("/booking", payload=booking_payload)
        booking_id = create_resp.json()["bookingid"]

        delete_resp = auth_client.delete(f"/booking/{booking_id}")
        assert delete_resp.status_code == 201         # restful-booker returns 201 on delete

    def test_deleted_booking_returns_404_on_get(self, auth_client, booking_payload):
        create_resp = auth_client.post("/booking", payload=booking_payload)
        booking_id = create_resp.json()["bookingid"]

        auth_client.delete(f"/booking/{booking_id}")

        get_resp = auth_client.get(f"/booking/{booking_id}")
        assert get_resp.status_code == 404

    def test_delete_without_auth_returns_403(self, client, created_booking_id):
        """Unauthenticated DELETE should be rejected."""
        response = client.delete(f"/booking/{created_booking_id}")
        assert response.status_code == 403
