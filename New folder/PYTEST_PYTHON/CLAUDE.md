# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Industry-standard **Selenium + pytest** UI/API test automation framework for a JioHotstar-style OTT streaming application. Tests cover login, home, search, video player, subscription, watchlist, and user profile flows.

---

## Commands

```bash
# Install dependencies
pip install -r requirements.txt

# Run all tests
pytest

# Run by marker
pytest -m sanity
pytest -m smoke
pytest -m regression
pytest -m e2e
pytest -m negative

# Run only UI or API tests
pytest -m ui
pytest -m api

# Run a specific module
pytest tests/ui/auth/test_login.py
pytest tests/ui/search/test_search.py

# Run a single test by name
pytest tests/ui/auth/test_login.py::TestLogin::test_login_valid_email_password

# Run with a different browser
pytest --browser=firefox
pytest --browser=edge
pytest --headless

# Run against a specific environment
ENV=production pytest -m smoke

# Parallel execution (n workers)
pytest -n 4

# Generate and view Allure report
pytest --alluredir=reports/allure-results
allure serve reports/allure-results
```

---

## Architecture

```
PYTEST_PYTHON/
├── config/
│   ├── config.py          # Central Config class — reads .env then config.json fallback
│   └── config.json        # Environment URLs, timeouts, test data defaults
├── utilities/
│   ├── driver_factory.py  # Creates Chrome/Firefox/Edge WebDriver (webdriver-manager)
│   ├── wait_helper.py     # Explicit wait wrappers around WebDriverWait
│   ├── screenshot_util.py # Saves screenshots to reports/screenshots/
│   ├── soft_assert.py     # Collects assertion failures, raises at test end
│   ├── api_client.py      # requests.Session wrapper (GET/POST/PUT/DELETE + auth header)
│   ├── data_generator.py  # Faker-based random user/content data
│   └── logger.py          # Root logger — console INFO + file DEBUG
├── pages/                 # Page Object Model
│   ├── base_page.py       # All pages inherit this; wraps Selenium interactions
│   ├── login_page.py
│   ├── home_page.py
│   ├── search_page.py
│   ├── content_detail_page.py
│   ├── player_page.py
│   ├── subscription_page.py
│   ├── watchlist_page.py
│   ├── profile_page.py
│   └── continue_watching_page.py
├── test_data/
│   ├── __init__.py        # TestData class — preloads JSON files as class attributes
│   ├── json_payloads/     # users.json, content.json — test input data
│   └── json_schema/       # JSON Schema files for API response validation
├── tests/
│   ├── ui/                # Selenium browser tests organised by feature
│   │   ├── auth/          # TC-AUTH-*   login, logout, forgot password
│   │   ├── content/       # TC-HOME-*   home page, navigation, trays
│   │   ├── search/        # TC-SRCH-*   search, filters, no-results
│   │   ├── player/        # TC-PLYR-*   play/pause, fullscreen, controls
│   │   ├── subscription/  # TC-SUB-*    plans, payment, coupon
│   │   ├── watchlist/         # TC-WL-*     add/remove, persistence
│   │   ├── profile/           # TC-PROF-*   settings, name update, logout
│   │   └── continue_watching/ # TC-CW-*     tray, resume, progress bar
│   └── api/               # requests-based REST tests
│       ├── auth/          # TC-API-AUTH-*
│       └── content/       # TC-API-CNT-*
├── conftest.py            # All fixtures: driver, page objects, logged_in_driver, screenshot on fail
├── pytest.ini             # Markers, addopts (html+allure reports, reruns), log config
├── .env                   # Credentials and browser defaults (not committed)
└── requirements.txt
```

---

## Key Conventions

### Test case IDs
Every test has a unique ID in the title: `TC-{MODULE}-{NNN}`. Prefix pattern:
- `TC-AUTH-*` — authentication
- `TC-HOME-*` — home page
- `TC-SRCH-*` — search
- `TC-PLYR-*` — player
- `TC-SUB-*` — subscription
- `TC-WL-*` — watchlist
- `TC-PROF-*` — profile
- `TC-API-AUTH-*` — API auth
- `TC-API-CNT-*` — API content

### Markers
Each test carries one **tier marker** + one or more **domain markers**:

| Tier marker | Purpose |
|---|---|
| `sanity` | Minimum viable check; runs in < 5 min; gate for further testing |
| `smoke` | Pre-release breadth check |
| `regression` | Full feature coverage |
| `e2e` | End-to-end user journey |
| `negative` | Error paths and edge cases |

### Allure decorators (required on every test)
```python
@allure.epic("JioHotstar")
@allure.feature("Feature Name")
@allure.story("...")
@allure.title("TC-XXX-NNN | [MARKER] Human-readable description")
@allure.severity(allure.severity_level.BLOCKER | CRITICAL | NORMAL | MINOR)
```

### Fixtures
- `driver` — function-scoped fresh browser per test
- `driver_class` — class-scoped browser (shared across test class)
- `logged_in_driver` — driver already authenticated as valid user
- `premium_logged_in_driver` — driver authenticated as premium user
- Page fixtures (`login_page`, `home_page`, …) wrap driver in a page object

### Adding new tests
1. Create `test_data` entries in JSON if needed
2. Add/update locators in the relevant page object under `pages/`
3. Write the test in `tests/ui/<feature>/test_<feature>.py`
4. Decorate with `@allure.*`, `@pytest.mark.<tier>`, `@pytest.mark.<domain>`
5. Name it `TC-{MODULE}-{NNN}` continuing the existing sequence
