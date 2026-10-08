"""
test_booking_read.py - GET /booking  and  GET /booking/{id}
Covers: list all, filter by name, get by id, not-found, response structure
"""
import pytest
from .base_test import BaseTest


class TestGetAllBookings(BaseTest):

    ENDPOINT = "/booking"

    # ── GET /booking ─────────────────────────────────────────────────────────

    def test_get_all_bookings_returns_200(self, api_session, base_url):
        resp = api_session.get(f"{base_url}{self.ENDPOINT}")
        self.assert_ok(resp)

    def test_get_all_bookings_returns_list(self, api_session, base_url):
        resp = api_session.get(f"{base_url}{self.ENDPOINT}")
        body = resp.json()
        assert isinstance(body, list), f"Expected list, got {type(body)}"

    def test_get_all_bookings_list_contains_ids(self, api_session, base_url):
        resp = api_session.get(f"{base_url}{self.ENDPOINT}")
        body = resp.json()
        assert len(body) > 0, "Booking list should not be empty"
        for item in body[:5]:  # spot-check first 5
            assert "bookingid" in item, f"Item missing 'bookingid': {item}"

    def test_get_all_bookings_response_time(self, api_session, base_url):
        resp = api_session.get(f"{base_url}{self.ENDPOINT}")
        self.assert_response_time(resp, max_ms=5000)

    # ── GET /booking?firstname=&lastname= ────────────────────────────────────

    def test_filter_by_firstname(self, api_session, base_url, created_booking):
        """Create a booking then query by its firstname — must appear in results."""
        fname = created_booking["data"]["firstname"]
        resp = api_session.get(
            f"{base_url}{self.ENDPOINT}", params={"firstname": fname}
        )
        self.assert_ok(resp)
        ids = [b["bookingid"] for b in resp.json()]
        assert created_booking["id"] in ids, (
            f"Booking {created_booking['id']} not found when filtering by firstname={fname}"
        )

    def test_filter_by_lastname(self, api_session, base_url, created_booking):
        lname = created_booking["data"]["lastname"]
        resp = api_session.get(
            f"{base_url}{self.ENDPOINT}", params={"lastname": lname}
        )
        self.assert_ok(resp)
        ids = [b["bookingid"] for b in resp.json()]
        assert created_booking["id"] in ids

    def test_filter_by_checkin_date(self, api_session, base_url, created_booking):
        checkin = created_booking["data"]["bookingdates"]["checkin"]
        resp = api_session.get(
            f"{base_url}{self.ENDPOINT}", params={"checkin": checkin}
        )
        self.assert_ok(resp)

    def test_filter_by_checkout_date(self, api_session, base_url, created_booking):
        checkout = created_booking["data"]["bookingdates"]["checkout"]
        resp = api_session.get(
            f"{base_url}{self.ENDPOINT}", params={"checkout": checkout}
        )
        self.assert_ok(resp)

    def test_filter_nonexistent_name_returns_empty(self, api_session, base_url):
        resp = api_session.get(
            f"{base_url}{self.ENDPOINT}",
            params={"firstname": "ZZZNoSuchPersonXXX"},
        )
        self.assert_ok(resp)
        assert resp.json() == [], f"Expected empty list, got: {resp.json()}"


class TestGetBookingById(BaseTest):

    # ── GET /booking/{id} ────────────────────────────────────────────────────

    def test_get_booking_by_id_returns_200(self, api_session, base_url, created_booking):
        bid = created_booking["id"]
        resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_ok(resp)

    def test_get_booking_by_id_has_required_fields(
        self, api_session, base_url, created_booking
    ):
        bid = created_booking["id"]
        resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_booking_fields(resp.json())

    def test_get_booking_by_id_data_matches_creation(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        data = created_booking["data"]
        resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_ok(resp)
        booking = resp.json()
        self.assert_field_equals(booking, "firstname",   data["firstname"])
        self.assert_field_equals(booking, "lastname",    data["lastname"])
        self.assert_field_equals(booking, "totalprice",  data["totalprice"])
        self.assert_field_equals(booking, "depositpaid", data["depositpaid"])

    def test_get_booking_bookingdates_shape(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = api_session.get(f"{base_url}/booking/{bid}")
        dates = resp.json().get("bookingdates", {})
        assert "checkin"  in dates, "bookingdates.checkin missing"
        assert "checkout" in dates, "bookingdates.checkout missing"

    def test_get_nonexistent_booking_returns_404(self, api_session, base_url):
        resp = api_session.get(f"{base_url}/booking/999999999")
        self.assert_not_found(resp)

    def test_get_booking_response_time(self, api_session, base_url, created_booking):
        bid  = created_booking["id"]
        resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_response_time(resp, max_ms=5000)

    @pytest.mark.parametrize("bad_id", ["abc", "!@#", " "])
    def test_get_booking_invalid_id_types(
        self, api_session, base_url, bad_id
    ):
        resp = api_session.get(f"{base_url}/booking/{bad_id}")
        assert resp.status_code in (400, 404), (
            f"Expected 400/404 for id={bad_id!r}, got {resp.status_code}"
        )

    def test_get_booking_id_consistent_across_calls(
        self, api_session, base_url, created_booking
    ):
        """Same booking should return identical data on two consecutive reads."""
        bid = created_booking["id"]
        r1 = api_session.get(f"{base_url}/booking/{bid}").json()
        r2 = api_session.get(f"{base_url}/booking/{bid}").json()
        assert r1 == r2, "Booking data changed between two reads"
