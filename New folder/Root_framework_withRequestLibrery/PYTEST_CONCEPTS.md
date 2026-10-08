# Pytest Concepts — Interview Ready Guide

---

## 1. What is Pytest?

Pytest is a Python testing framework used to write and run tests.
It automatically discovers test files and functions and reports pass/fail results.

**Use case:** Used in API testing, unit testing, UI testing (with Selenium/Playwright).

---

## 2. Test Discovery Rules

Pytest automatically finds tests by these rules:

| Rule | Example |
|---|---|
| File must start with `test_` or end with `_test.py` | `test_login.py` |
| Function must start with `test_` | `def test_login():` |
| Class must start with `Test` (no `__init__`) | `class TestLogin:` |

```python
# pytest finds this automatically
def test_addition():
    assert 1 + 1 == 2
```

---

## 3. assert — How pytest checks results

Pytest uses plain Python `assert` statements. No special methods needed.

```python
def test_example():
    assert 2 + 2 == 4               # passes
    assert "hello" in "hello world" # passes
    assert response.status_code == 200
    assert isinstance(booking_id, int)
```

**Why pytest assert is special:** If it fails, pytest shows the exact values that failed — not just "AssertionError".

---

## 4. Fixtures — Setup code shared across tests

A fixture is a function that **prepares data or resources** before a test runs.
Decorated with `@pytest.fixture`.

```python
import pytest

@pytest.fixture
def user_data():
    return {"name": "Alice", "age": 25}

def test_user_name(user_data):        # pytest injects user_data automatically
    assert user_data["name"] == "Alice"

def test_user_age(user_data):
    assert user_data["age"] == 25
```

**Use case:** Avoids repeating setup code in every test. Create once, reuse everywhere.

---

## 5. yield in Fixtures — Setup + Teardown together

`yield` splits a fixture into two parts:
- Code **before** `yield` = setup (runs before test)
- Code **after** `yield`  = teardown (runs after test, even if test fails)

```python
@pytest.fixture
def created_booking(api_session, base_url):
    # SETUP — runs before test
    resp = api_session.post(f"{base_url}/booking", json=payload)
    booking_id = resp.json()["bookingid"]

    yield {"id": booking_id}    # test runs here and receives this value

    # TEARDOWN — runs after test (cleanup)
    api_session.delete(f"{base_url}/booking/{booking_id}")
```

**Use case:** Create a booking before test, delete it after. Test always has clean data.

---

## 6. conftest.py — Shared fixture file

`conftest.py` is a special file where you define fixtures shared across multiple test files.
Pytest loads it **automatically** — you never need to import it.

```
Tests/
  conftest.py              ← fixtures defined here
  test_booking_create.py   ← uses fixtures from conftest.py
  test_booking_read.py     ← also uses fixtures from conftest.py
```

```python
# conftest.py
@pytest.fixture
def base_url():
    return "https://restful-booker.herokuapp.com"

# test_booking_create.py — no import needed, pytest finds it automatically
def test_something(base_url):
    print(base_url)
```

**Use case:** Put `api_session`, `base_url`, `auth_token` in conftest.py so every test file can use them.

---

## 7. scope — How long a fixture lives

Scope controls **when pytest creates and destroys** the fixture.

| scope | Created once per... | Best for |
|---|---|---|
| `"function"` *(default)* | every single test | fresh data per test |
| `"class"` | every test class | shared data within a class |
| `"module"` | every `.py` test file | shared data within a file |
| `"session"` | entire pytest run | login token, HTTP session |

```python
# Created ONCE for all tests — login happens only one time
@pytest.fixture(scope="session")
def auth_token(base_url, credentials):
    response = requests.post(f"{base_url}/auth", json=credentials)
    return response.json()["token"]


# Created fresh for EVERY test — safe, independent
@pytest.fixture(scope="function")
def sample_payload():
    return {"firstname": "John", "lastname": "Doe", "totalprice": 150}
```

**Interview answer:** Use `scope="session"` for expensive setup like login. Use `scope="function"` when tests must not share state.

---

## 8. @pytest.mark.parametrize — Run same test with different data

Instead of writing 4 tests, write ONE test and pass a list of values.
Pytest runs the test once for each value.

```python
# Without parametrize — repetitive
def test_price_zero():     resp = post(price=0);    assert resp.status == 200
def test_price_one():      resp = post(price=1);    assert resp.status == 200
def test_price_large():    resp = post(price=9999); assert resp.status == 200

# With parametrize — clean
@pytest.mark.parametrize("price", [0, 1, 9999, 1000000])
def test_create_booking_various_prices(api_session, base_url, price):
    payload = {"totalprice": price, ...}
    resp = api_session.post(f"{base_url}/booking", json=payload)
    assert resp.status_code == 200
```

Pytest runs 4 separate tests:
```
test_create_booking_various_prices[0]
test_create_booking_various_prices[1]
test_create_booking_various_prices[9999]
test_create_booking_various_prices[1000000]
```

### Multiple parameters

```python
@pytest.mark.parametrize("name, price", [
    ("Alice", 100),
    ("Bob",   200),
    ("Carol", 300),
])
def test_booking(api_session, name, price):
    ...
# runs 3 times — one row at a time
```

---

## 9. @pytest.mark.skip — Skip a test

```python
@pytest.mark.skip(reason="API is currently down")
def test_something():
    ...

# Skip based on a condition
import sys
@pytest.mark.skipif(sys.platform == "win32", reason="Not supported on Windows")
def test_linux_only():
    ...
```

---

## 10. @pytest.mark.xfail — Expected to fail

Marks a test as "known to fail". Pytest reports it as `xfail` not as ERROR.

```python
@pytest.mark.xfail(reason="Bug #123 not fixed yet")
def test_known_bug():
    assert 1 == 2   # fails, but pytest shows xfail — not a red failure
```

---

## 11. autouse=True — Run fixture for every test automatically

Fixture runs for every test without listing it as a parameter.

```python
@pytest.fixture(autouse=True)
def reset_database():
    db.clear()
    yield
    db.clear()

# This test gets reset_database automatically — no need to add it as parameter
def test_something():
    ...
```

---

## 12. pytest.raises — Test that an exception is raised

```python
def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        result = 10 / 0   # must raise this error, otherwise test FAILS

# Check the error message too
def test_value_error():
    with pytest.raises(ValueError, match="invalid input"):
        raise ValueError("invalid input")
```

---

## 13. tmp_path — Built-in fixture for temporary files

Pytest provides `tmp_path` for free — no setup needed.

```python
def test_file_writing(tmp_path):
    file = tmp_path / "data.txt"
    file.write_text("hello")
    assert file.read_text() == "hello"
# temp folder deleted automatically after test
```

---

## 14. capsys — Capture print output

```python
def test_print_output(capsys):
    print("hello world")
    captured = capsys.readouterr()
    assert "hello world" in captured.out
```

---

## 15. monkeypatch — Temporarily replace values or functions

Used to mock environment variables, functions, or class attributes for a test.

```python
def test_env_var(monkeypatch):
    monkeypatch.setenv("BASE_URL", "http://localhost:8080")
    assert os.getenv("BASE_URL") == "http://localhost:8080"
# value is restored automatically after test

def test_mock_function(monkeypatch):
    monkeypatch.setattr(requests, "get", lambda url: FakeResponse())
```

---

## 16. Running Tests — CLI Commands

```bash
pytest                              # run all tests
pytest Tests/                       # run all tests in Tests folder
pytest Tests/test_booking_create.py # run one file
pytest -k "test_create"             # run tests whose name contains "test_create"
pytest -m "smoke"                   # run tests marked with @pytest.mark.smoke
pytest -v                           # verbose — show each test name
pytest -s                           # show print() output
pytest --tb=short                   # short traceback on failure
pytest -x                           # stop after first failure
pytest --html=report.html           # generate HTML report (needs pytest-html)
```

---

## 17. Custom Markers — Tag your tests

Define a custom tag and run only those tests.

```python
# mark a test
@pytest.mark.smoke
def test_login():
    ...

@pytest.mark.regression
def test_full_flow():
    ...
```

```bash
pytest -m smoke       # run only smoke tests
pytest -m regression  # run only regression tests
```

Register markers in `pytest.ini` to avoid warnings:
```ini
[pytest]
markers =
    smoke: fast critical path tests
    regression: full regression suite
```

---

## 18. Fixture Dependency — Fixtures can use other fixtures

```python
@pytest.fixture(scope="session")
def base_url():
    return "https://restful-booker.herokuapp.com"

@pytest.fixture(scope="session")
def auth_token(base_url):          # base_url is injected here
    resp = requests.post(f"{base_url}/auth", json=creds)
    return resp.json()["token"]

@pytest.fixture(scope="session")
def api_session(base_url, auth_token):   # both injected here
    session = requests.Session()
    session.headers.update({"Cookie": f"token={auth_token}"})
    yield session
    session.close()
```

Dependency chain:
```
base_url → auth_token → api_session → test
```

---

## 19. Class-based Tests

Group related tests inside a class. Class must start with `Test`, no `__init__`.

```python
class TestCreateBooking:

    ENDPOINT = "/booking"

    def test_returns_200(self, api_session, base_url):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json={})
        assert resp.status_code == 200

    def test_has_booking_id(self, api_session, base_url):
        resp = api_session.post(f"{base_url}{self.ENDPOINT}", json={})
        assert "bookingid" in resp.json()
```

---

## 20. Full Picture — How it all connects

```
conftest.py
│
├── base_url        (scope=session)  → reads .env once
├── credentials     (scope=session)  → reads .env once
├── auth_token      (scope=session)  → POST /auth once, reuse token
├── api_session     (scope=session)  → one HTTP session for all tests
├── sample_payload  (scope=function) → fresh dict per test
└── created_booking (scope=function) → creates + deletes booking per test


test file
│
├── @pytest.mark.parametrize  → run same test with many values
├── @pytest.mark.skip         → skip a test
├── @pytest.mark.xfail        → known failure, don't report as error
└── def test_xxx(api_session, base_url, sample_payload):
        ↑ pytest injects fixtures by matching parameter names
```

---

## Quick Interview Answers

| Question | Answer |
|---|---|
| What is a fixture? | A function that sets up data/resources before a test runs |
| What is conftest.py? | File where shared fixtures are defined — auto-loaded by pytest |
| What is scope? | Controls how long a fixture lives — function/class/module/session |
| What is parametrize? | Run same test with different input values |
| What is yield in fixture? | Code before yield = setup, code after yield = teardown |
| What is autouse? | Fixture runs automatically for every test without being listed |
| How to skip a test? | `@pytest.mark.skip(reason="...")` |
| How to test exceptions? | `with pytest.raises(ExceptionType):` |
| What is monkeypatch? | Built-in fixture to mock/replace values temporarily in a test |
