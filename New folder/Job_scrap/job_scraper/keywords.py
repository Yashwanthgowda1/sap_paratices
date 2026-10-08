"""
Centralised search keyword lists shared across all scrapers.
Broad terms so each portal returns more relevant matches than "SDET" alone.
"""

# Used by LinkedIn (display text) and Indeed / Google (query strings)
SEARCH_KEYWORDS = [
    "QA Automation Engineer",
    "Automation Testing",
    "Test Automation Engineer",
    "SDET",
    "Software Testing Engineer",
    "QA Engineer Selenium",
    "API Test Automation",
    "Performance Testing Engineer",
    "Quality Assurance Automation",
    "Selenium Automation Tester",
]

# Naukri uses hyphenated URL slugs — one per search page
NAUKRI_SLUGS = [
    "qa-automation-engineer",
    "automation-testing",
    "test-automation-engineer",
    "sdet",
    "software-testing",
    "qa-engineer",
    "selenium-automation",
    "api-testing",
    "performance-testing",
    "quality-assurance",
]

# Google Jobs / SerpAPI — full natural-language queries with location hint
def google_queries(location: str) -> list:
    base = [
        "QA Automation Engineer",
        "SDET Software Development Engineer in Test",
        "Test Automation Selenium Playwright",
        "Automation Testing API Selenium",
        "Performance Testing JMeter k6",
        "QA Engineer Cypress RestAssured",
    ]
    return [f"{q} {location}" for q in base]
