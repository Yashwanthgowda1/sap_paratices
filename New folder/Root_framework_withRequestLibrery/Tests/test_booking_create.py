"""
test_booking_create.py - POST /booking
Covers: happy path, field validation, edge cases, response structure
"""
import pytest
from .base_test import BaseTest


class TestCreateBooking(BaseTest):

    ENDPOINT = "/booking"

    # ── Happy path ───────────────────────────────────────────────────────────

    def test_create_booking_returns_200(self, api_session, base_url, sample_payload):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=sample_payload)
        self.assert_ok(resp)

    def test_create_booking_response_has_booking_id(
        self, api_session, base_url, sample_payload
    ):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=sample_payload)
        self.assert_ok(resp)
        body = resp.json()
        self.assert_json_key(resp, "bookingid", "booking")
        assert isinstance(body["bookingid"], int), "bookingid must be an integer"

    def test_create_booking_response_matches_payload(
        self, api_session, base_url, sample_payload
    ):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=sample_payload)
        self.assert_ok(resp)
        booking = resp.json()["booking"]
        self.assert_booking_matches_payload(booking, sample_payload)

    def test_create_booking_response_time(self, api_session, base_url, sample_payload):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=sample_payload)
        self.assert_response_time(resp, max_ms=5000)

    # ── Field-level validation ───────────────────────────────────────────────

    def test_booking_id_is_positive_integer(self, api_session, base_url, sample_payload):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=sample_payload)
        booking_id = resp.json()["bookingid"]
        assert booking_id > 0, f"bookingid must be > 0, got {booking_id}"

    def test_firstname_stored_correctly(self, api_session, base_url):
        payload = {
            "firstname": "Alice",
            "lastname":  "Smith",
            "totalprice": 200,
            "depositpaid": False,
            "bookingdates": {"checkin": "2025-03-01", "checkout": "2025-03-05"},
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        booking = resp.json()["booking"]
        self.assert_field_equals(booking, "firstname", "Alice")

    def test_totalprice_stored_as_number(self, api_session, base_url):
        payload = {
            "firstname": "Test", "lastname": "Price",
            "totalprice": 999,
            "depositpaid": True,
            "bookingdates": {"checkin": "2025-04-01", "checkout": "2025-04-03"},
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        booking = resp.json()["booking"]
        assert isinstance(booking["totalprice"], (int, float))
        self.assert_field_equals(booking, "totalprice", 999)

    def test_depositpaid_stored_as_boolean(self, api_session, base_url):
        for deposit in (True, False):
            payload = {
                "firstname": "Test", "lastname": "Deposit",
                "totalprice": 100, "depositpaid": deposit,
                "bookingdates": {"checkin": "2025-05-01", "checkout": "2025-05-02"},
            }
            resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
            booking = resp.json()["booking"]
            self.assert_field_equals(booking, "depositpaid", deposit)

    def test_bookingdates_checkin_checkout_stored(self, api_session, base_url):
        payload = {
            "firstname": "Date", "lastname": "Check",
            "totalprice": 50, "depositpaid": True,
            "bookingdates": {"checkin": "2025-06-10", "checkout": "2025-06-20"},
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        dates = resp.json()["booking"]["bookingdates"]
        assert dates["checkin"]  == "2025-06-10"
        assert dates["checkout"] == "2025-06-20"

    def test_additionalneeds_stored(self, api_session, base_url):
        payload = {
            "firstname": "Extra", "lastname": "Needs",
            "totalprice": 75, "depositpaid": False,
            "bookingdates": {"checkin": "2025-07-01", "checkout": "2025-07-05"},
            "additionalneeds": "Late checkout",
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        booking = resp.json()["booking"]
        self.assert_field_equals(booking, "additionalneeds", "Late checkout")

    # ── Edge / negative cases ────────────────────────────────────────────────

    def test_create_without_additionalneeds(self, api_session, base_url):
        """additionalneeds is optional — should succeed without it."""
        payload = {
            "firstname": "No", "lastname": "Extras",
            "totalprice": 120, "depositpaid": True,
            "bookingdates": {"checkin": "2025-08-01", "checkout": "2025-08-03"},
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        self.assert_ok(resp)
        assert "bookingid" in resp.json()

    def test_create_multiple_bookings_unique_ids(self, api_session, base_url, sample_payload):
        ids = set()
        for _ in range(3):
            resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=sample_payload)
            self.assert_ok(resp)
            ids.add(resp.json()["bookingid"])
        assert len(ids) == 3, "Duplicate booking IDs returned"

    @pytest.mark.parametrize("firstname", ["A", "John-Paul", "José", "O'Brien"])
    def test_create_booking_various_firstnames(
        self, api_session, base_url, firstname
    ):
        payload = {
            "firstname": firstname, "lastname": "Test",
            "totalprice": 100, "depositpaid": True,
            "bookingdates": {"checkin": "2025-09-01", "checkout": "2025-09-02"},
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        self.assert_ok(resp)

    @pytest.mark.parametrize("price", [0, 1, 9999, 1000000])
    def test_create_booking_various_prices(self, api_session, base_url, price):
        payload = {
            "firstname": "Price", "lastname": "Test",
            "totalprice": price,
            "depositpaid": False,
            "bookingdates": {"checkin": "2025-10-01", "checkout": "2025-10-02"},
        }
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json=payload)
        self.assert_ok(resp)
        assert resp.json()["booking"]["totalprice"] == price
