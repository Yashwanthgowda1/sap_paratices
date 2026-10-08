"""
base_test.py - Shared assertion helpers used across all test modules.
Import BaseTest or call helpers directly — no pytest magic here.
"""
import jsonschema


class BaseTest:
    """Mixin with reusable assertion helpers."""

    # ── Status code assertions ───────────────────────────────────────────────

    def assert_status(self, response, expected: int):
        assert response.status_code == expected, (
            f"Expected {expected}, got {response.status_code}. Body: {response.text}"
        )

    def assert_ok(self, response):
        self.assert_status(response, 200)

    def assert_created(self, response):
        self.assert_status(response, 201)

    def assert_not_found(self, response):
        self.assert_status(response, 404)

    def assert_forbidden(self, response):
        self.assert_status(response, 403)

    # ── Header assertions ────────────────────────────────────────────────────

    def assert_content_type_json(self, response):
        ct = response.headers.get("Content-Type", "")
        assert "application/json" in ct or "text/plain" in ct, (
            f"Expected JSON content-type, got: {ct}"
        )

    def assert_response_time(self, response, max_ms: int = 5000):
        elapsed = response.elapsed.total_seconds() * 1000
        assert elapsed <= max_ms, (
            f"Response too slow: {elapsed:.0f}ms (limit {max_ms}ms)"
        )

    # ── JSON body assertions ─────────────────────────────────────────────────

    def assert_json_key(self, response, *keys):
        """Assert that all given keys exist in the top-level JSON."""
        body = response.json()
        for key in keys:
            assert key in body, f"Key '{key}' missing from response: {body}"

    def assert_field_equals(self, body: dict, field: str, expected):
        assert body.get(field) == expected, (
            f"Field '{field}': expected {expected!r}, got {body.get(field)!r}"
        )

    def assert_not_empty(self, value, label: str = "value"):
        assert value, f"{label} must not be empty/falsy, got: {value!r}"

    # ── Schema validation ────────────────────────────────────────────────────

    def assert_schema(self, body: dict, schema: dict):
        """Validate body against a JSON Schema dict. Raises AssertionError on failure."""
        try:
            jsonschema.validate(instance=body, schema=schema)
        except jsonschema.ValidationError as exc:
            raise AssertionError(f"Schema validation failed: {exc.message}") from exc

    # ── Booking-specific ─────────────────────────────────────────────────────

    def assert_booking_fields(self, booking: dict):
        required = [
            "firstname", "lastname", "totalprice",
            "depositpaid", "bookingdates",
        ]
        for field in required:
            assert field in booking, (
                f"Booking missing required field: '{field}'"
            )
        assert "checkin"  in booking["bookingdates"]
        assert "checkout" in booking["bookingdates"]

    def assert_booking_matches_payload(self, booking: dict, payload: dict):
        """Assert every field in payload exists and matches booking response."""
        for key, value in payload.items():
            if key == "bookingdates":
                self.assert_field_equals(
                    booking["bookingdates"], "checkin",
                    value["checkin"]
                )
                self.assert_field_equals(
                    booking["bookingdates"], "checkout",
                    value["checkout"]
                )
            else:
                self.assert_field_equals(booking, key, value)
