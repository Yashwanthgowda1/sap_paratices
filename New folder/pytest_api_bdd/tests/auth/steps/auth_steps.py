"""
steps/auth_steps.py
-------------------
Step definitions for auth.feature.

DataTable pattern:
  - table is passed as a raw string from the feature file
  - parse it manually into a list of dicts inside the step
  - loop and call API for each row
  - store all results in context for Then to validate
"""

import pytest
from pytest_bdd import given, when, then, parsers
from utils.data_loader import parse_datatable


@pytest.fixture
def context():
    return {}


# ── GIVEN ─────────────────────────────────────────────────────────────────────

@given("the auth endpoint is available")
def auth_endpoint_available(client, context):
    response = client.get("/ping")
    assert response.status_code == 201, "API not reachable"
    context["client"] = client


# ── WHEN ──────────────────────────────────────────────────────────────────────

@when(parsers.parse('I send a POST to "{endpoint}" with valid credentials'))
def post_valid_credentials(context, endpoint):
    context["response"] = context["client"].post(
        endpoint,
        payload={"username": "admin", "password": "password123"},
    )


@when(parsers.parse('I send a POST to "{endpoint}" with invalid password'))
def post_invalid_password(context, endpoint):
    context["response"] = context["client"].post(
        endpoint,
        payload={"username": "admin", "password": "wrong_password"},
    )


@when(parsers.parse("I send login requests for the following credentials\n{table}"))
def post_datatable_credentials(context, table):
    """
    DataTable — same as Java:
        DataTable dataTable
        List<Map<String,String>> rows = dataTable.asMaps()

    Here 'table' is the raw pipe-delimited string from the feature file:
        | username | password    |
        |          | password123 |
        | admin    |             |
        |          |             |

    We parse it into a list of dicts — then loop exactly like Java .asMaps()
    """
    rows = parse_datatable(table)                        # list of dicts (default)
    # rows = [
    #   {"username": "",      "password": "password123"},
    #   {"username": "admin", "password": ""},
    #   {"username": "",      "password": ""}
    # ]

    results = []
    for row in rows:
        response = context["client"].post(
            "/auth",
            payload={
                "username": row["username"],   # ← from DataTable row
                "password": row["password"],   # ← from DataTable row
            },
        )
        results.append({
            "username": row["username"],
            "password": row["password"],
            "status":   response.status_code,
            "body":     response.json(),
        })

    context["results"] = results   # store all for Then to validate


# ── THEN ──────────────────────────────────────────────────────────────────────

@then(parsers.parse("the response status code should be {status_code:d}"))
def check_status_code(context, status_code):
    assert context["response"].status_code == status_code, (
        f"Expected {status_code}, got {context['response'].status_code}"
    )


@then(parsers.parse('the response body should contain a "{key}"'))
def check_body_has_key(context, key):
    body = context["response"].json()
    assert key in body and body[key], f"Key '{key}' missing or empty: {body}"


@then(parsers.parse('the response body should contain reason "{reason}"'))
def check_reason(context, reason):
    assert context["response"].json().get("reason") == reason


@then("all login attempts should be rejected")
def check_all_rejected(context):
    failed = []
    for r in context["results"]:
        body  = r["body"]
        token = body.get("token")
        if token is not None and body.get("reason") is None:
            failed.append(r)

    assert not failed, (
        f"{len(failed)} row(s) were NOT rejected:\n" +
        "\n".join(
            f"  username='{r['username']}' password='{r['password']}' → {r['body']}"
            for r in failed
        )
    )
