"""
test_schema_validation.py - JSON Schema validation for all endpoints
Validates create response, get-by-id, update, and patch against JSON Schema.
"""
import pytest
import jsonschema
from .base_test import BaseTest

# ── Inline schemas (mirrors resource/Json_schema/*.json) ─────────────────────

CREATE_RESPONSE_SCHEMA = {
    "type": "object",
    "required": ["bookingid", "booking"],
    "properties": {
        "bookingid": {"type": "integer", "minimum": 1},
        "booking": {
            "type": "object",
            "required": ["firstname", "lastname", "totalprice", "depositpaid", "bookingdates"],
            "properties": {
                "firstname":   {"type": "string", "minLength": 1},
                "lastname":    {"type": "string", "minLength": 1},
                "totalprice":  {"type": "number",  "minimum": 0},
                "depositpaid": {"type": "boolean"},
                "bookingdates": {
                    "type": "object",
                    "required": ["checkin", "checkout"],
                    "properties": {
                        "checkin":  {"type": "string"},
                        "checkout": {"type": "string"},
                    },
                    "additionalProperties": False,
                },
                "additionalneeds": {"type": "string"},
            },
        },
    },
    "additionalProperties": False,
}

BOOKING_DETAIL_SCHEMA = {
    "type": "object",
    "required": ["firstname", "lastname", "totalprice", "depositpaid", "bookingdates"],
    "properties": {
        "firstname":   {"type": "string", "minLength": 1},
        "lastname":    {"type": "string", "minLength": 1},
        "totalprice":  {"type": "number", "minimum": 0},
        "depositpaid": {"type": "boolean"},
        "bookingdates": {
            "type": "object",
            "required": ["checkin", "checkout"],
            "properties": {
                "checkin":  {"type": "string"},
                "checkout": {"type": "string"},
            },
            "additionalProperties": False,
        },
        "additionalneeds": {"type": "string"},
    },
}

BOOKING_LIST_ITEM_SCHEMA = {
    "type": "object",
    "required": ["bookingid"],
    "properties": {
        "bookingid": {"type": "integer", "minimum": 1},
    },
    "additionalProperties": False,
}

AUTH_RESPONSE_SCHEMA = {
    "type": "object",
    "required": ["token"],
    "properties": {
        "token": {"type": "string", "minLength": 5},
    },
}

AUTH_FAIL_SCHEMA = {
    "type": "object",
    "required": ["reason"],
    "properties": {
        "reason": {"type": "string"},
    },
}


class TestSchemaValidation(BaseTest):

    # ── Auth endpoint ─────────────────────────────────────────────────────────

    def test_auth_response_schema(self, base_url, credentials):
        import requests
        resp = requests.post(
            f"{base_url}/auth",
            json=credentials,
            headers={"Content-Type": "application/json"},
            timeout=15,
        )
        self.assert_ok(resp)
        self.assert_schema(resp.json(), AUTH_RESPONSE_SCHEMA)

    def test_auth_fail_response_schema(self, base_url):
        import requests
        resp = requests.post(
            f"{base_url}/auth",
            json={"username": "bad", "password": "bad"},
            timeout=15,
        )
        self.assert_ok(resp)
        body = resp.json()
        if "reason" in body:
            self.assert_schema(body, AUTH_FAIL_SCHEMA)

    # ── Create booking ────────────────────────────────────────────────────────

    def test_create_booking_response_schema(
        self, api_session, base_url, sample_payload
    ):
        resp = api_session.post(f"{base_url}/booking", json=sample_payload)
        self.assert_ok(resp)
        self.assert_schema(resp.json(), CREATE_RESPONSE_SCHEMA)

    def test_create_booking_id_is_integer(
        self, api_session, base_url, sample_payload
    ):
        resp = api_session.post(f"{base_url}/booking", json=sample_payload)
        booking_id = resp.json()["bookingid"]
        assert isinstance(booking_id, int), f"bookingid type: {type(booking_id)}"

    def test_create_booking_nested_dates_schema(
        self, api_session, base_url, sample_payload
    ):
        resp = api_session.post(f"{base_url}/booking", json=sample_payload)
        dates = resp.json()["booking"]["bookingdates"]
        date_schema = {
            "type": "object",
            "required": ["checkin", "checkout"],
            "properties": {
                "checkin":  {"type": "string", "pattern": r"^\d{4}-\d{2}-\d{2}$"},
                "checkout": {"type": "string", "pattern": r"^\d{4}-\d{2}-\d{2}$"},
            },
        }
        self.assert_schema(dates, date_schema)

    # ── Get booking by ID ─────────────────────────────────────────────────────

    def test_get_booking_by_id_schema(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = api_session.get(f"{base_url}/booking/{bid}")
        self.assert_ok(resp)
        self.assert_schema(resp.json(), BOOKING_DETAIL_SCHEMA)

    def test_get_booking_fields_are_correct_types(
        self, api_session, base_url, created_booking
    ):
        bid    = created_booking["id"]
        body   = api_session.get(f"{base_url}/booking/{bid}").json()
        assert isinstance(body["firstname"],   str),   "firstname must be str"
        assert isinstance(body["lastname"],    str),   "lastname must be str"
        assert isinstance(body["totalprice"],  (int, float)), "totalprice must be number"
        assert isinstance(body["depositpaid"], bool),  "depositpaid must be bool"
        assert isinstance(body["bookingdates"], dict), "bookingdates must be dict"

    # ── Get all bookings list ─────────────────────────────────────────────────

    def test_get_all_bookings_list_item_schema(self, api_session, base_url):
        resp  = api_session.get(f"{base_url}/booking")
        items = resp.json()
        assert isinstance(items, list)
        for item in items[:10]:
            self.assert_schema(item, BOOKING_LIST_ITEM_SCHEMA)

    # ── PUT response schema ───────────────────────────────────────────────────

    def test_put_booking_response_schema(
        self, api_session, base_url, created_booking
    ):
        bid     = created_booking["id"]
        payload = {
            "firstname":  "Schema",
            "lastname":   "Test",
            "totalprice": 100,
            "depositpaid": True,
            "bookingdates": {"checkin": "2026-04-01", "checkout": "2026-04-05"},
            "additionalneeds": "None",
        }
        resp = api_session.put(f"{base_url}/booking/{bid}", json=payload)
        self.assert_ok(resp)
        self.assert_schema(resp.json(), BOOKING_DETAIL_SCHEMA)

    # ── PATCH response schema ─────────────────────────────────────────────────

    def test_patch_booking_response_schema(
        self, api_session, base_url, created_booking
    ):
        bid  = created_booking["id"]
        resp = api_session.patch(
            f"{base_url}/booking/{bid}", json={"totalprice": 500}
        )
        self.assert_ok(resp)
        self.assert_schema(resp.json(), BOOKING_DETAIL_SCHEMA)

    # ── Field type strictness ─────────────────────────────────────────────────

    @pytest.mark.parametrize("field,expected_type", [
        ("firstname",   str),
        ("lastname",    str),
        ("totalprice",  (int, float)),
        ("depositpaid", bool),
    ])
    def test_create_booking_field_types(
        self, api_session, base_url, sample_payload, field, expected_type
    ):
        resp = api_session.post(f"{base_url}/booking", json=sample_payload)
        booking = resp.json()["booking"]
        assert isinstance(booking[field], expected_type), (
            f"Field '{field}' expected {expected_type}, got {type(booking[field])}"
        )
