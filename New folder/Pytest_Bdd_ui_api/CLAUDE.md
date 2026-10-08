# Pytest-BDD + UI + API Framework – JioHotstar

## What this project is
Industry-standard **pytest-bdd** framework for the JioHotstar OTT platform.
Covers one feature end-to-end: **Content Playback** (search → detail → play).
Each scenario exercises both the REST API layer and the Selenium UI layer.

---

## Folder structure
```
Pytest_Bdd_ui_api/
├── features/
│   └── content_playback/
│       └── content_playback_e2e.feature   ← Gherkin scenarios (BDD_E2E_001…)
├── tests/
│   └── step_definitions/
│       └── test_content_playback.py       ← All Given/When/Then bindings
├── pages/                                 ← Page Object Model
│   ├── base_page.py
│   ├── login_page.py
│   ├── home_page.py
│   ├── search_page.py
│   ├── content_detail_page.py
│   ├── player_page.py
│   ├── profile_page.py
│   └── watchlist_page.py
├── utilities/
│   ├── api_client.py                      ← requests wrapper (same headers as prod)
│   ├── driver_factory.py                  ← chrome/firefox/edge via webdriver-manager
│   ├── logger.py
│   ├── screenshot_util.py
│   └── wait_helper.py
├── config/
│   ├── config.py                          ← Config class, reads config.json + .env
│   └── config.json
├── test_data/
│   └── __init__.py                        ← Shared test data constants
├── conftest.py                            ← All pytest fixtures (driver, pages, API)
├── pytest.ini                             ← Markers, addopts, BDD paths
├── requirements.txt
└── .env                                   ← Credentials (not committed)
```

---

## Scenario IDs and markers
| ID | Tag(s) | Description |
|---|---|---|
| BDD_E2E_001 | sanity smoke e2e api ui | Search returns API + UI results |
| BDD_E2E_002 | smoke e2e subscription negative ui | Free user sees paywall |
| BDD_E2E_003 | regression e2e auth watchlist api ui | Login → search → play → watchlist |
| BDD_E2E_004 | regression e2e search ui | Parametrised search (4 keywords) |
| BDD_AUTH_001 | sanity smoke auth ui | Login with valid credentials |
| BDD_AUTH_002 | smoke auth negative ui | Invalid creds show error |
| BDD_AUTH_003 | regression auth ui | Logout clears session |
| BDD_API_AUTH_001 | sanity smoke api auth | POST /auth/login → 200 + token |
| BDD_API_AUTH_002 | smoke api auth negative | POST /auth/login → 401 wrong pw |
| BDD_API_CNT_001 | sanity api content | GET /content → 200 + array |

---

## Running tests

```bash
# Install dependencies
pip install -r requirements.txt

# Run all BDD scenarios
pytest tests/

# Run sanity suite only
pytest -m sanity

# Run only API scenarios
pytest -m api

# Run one specific BDD scenario
pytest -m BDD_E2E_001

# Run headless in Chrome
pytest --headless

# Run with Allure report
pytest tests/ && allure serve reports/allure-results
```

---

## Adding a new feature/scenario
1. Write the `.feature` file under `features/<feature-name>/`.
2. Add `scenarios("../../features/<feature-name>/<file>.feature")` in a new step definition file under `tests/step_definitions/`.
3. Implement `@given / @when / @then` functions; reuse existing ones where steps match exactly.
4. Add new page object methods if needed — never add locators outside page objects.
5. Register any new marker in `pytest.ini`.

---

## Conventions
- **Step text must match exactly** between `.feature` and `@given/@when/@then`.
- Use `parsers.parse(...)` for steps with variable data.
- Share state between steps via the `context` dict fixture (never use global variables).
- All page interactions go through `BasePage` helpers (`click`, `type_text`, `is_displayed`).
- All API calls go through `APIClient`; never use `requests` directly in step definitions.
- Screenshot on failure is automatic via `conftest.pytest_runtest_makereport`.
