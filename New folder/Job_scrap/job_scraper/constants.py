"""Shared constants for recommendation values, decision strings, and skill keywords."""

from __future__ import annotations

# ── Job recommendation labels ─────────────────────────────────────────────────
REC_APPLY = "apply"
REC_IMPROVE = "improve"
REC_SKIP = "skip"

# ── Apply-flow decision labels ────────────────────────────────────────────────
DECISION_APPLY = "apply"
DECISION_SKIP = "skip"
DECISION_STOP = "stop"
DECISION_SUBMIT = "submit"
DECISION_MANUAL = "manual"
DECISION_ERROR = "error"

# ── Login page indicators (URL / title substrings) ────────────────────────────
LOGIN_INDICATORS = [
    "sign in", "log in", "login", "sign up",
    "authwall", "checkpoint", "session_redirect",
]

# ── Known SDET/QA skill keywords (shared by ats_scorer and matcher) ──────────
SKILL_KEYWORDS: list[str] = [
    "Selenium", "Playwright", "Cypress", "Appium", "WebdriverIO",
    "Java", "Python", "JavaScript", "TypeScript", "Kotlin", "C#", "Ruby",
    "TestNG", "JUnit", "PyTest", "NUnit", "Mocha", "Jest",
    "REST Assured", "Postman", "Karate", "RestSharp", "Supertest",
    "JMeter", "k6", "Gatling", "Locust",
    "Jenkins", "GitHub Actions", "GitLab CI", "CircleCI", "Azure DevOps",
    "Docker", "Kubernetes", "K8s", "Helm", "AWS", "GCP", "Azure",
    "JIRA", "TestRail", "Zephyr", "Xray",
    "BDD", "Cucumber", "SpecFlow", "Behave",
    "Git", "Maven", "Gradle", "npm",
    "Allure", "Extent Reports",
    "SQL", "MongoDB", "MySQL", "PostgreSQL",
    "API Testing", "Integration Testing", "Performance Testing",
    "Mobile Testing", "Cross-browser Testing", "Regression Testing",
    "CI/CD", "Agile", "Scrum", "SDLC", "STLC",
    # Infrastructure & DevOps
    "Ansible", "Terraform", "Puppet", "Chef",
    "AWS Secrets Manager", "AWS Parameter Store", "Vault", "HashiCorp Vault",
    "Grafana", "Prometheus", "ELK Stack", "Kibana", "Elasticsearch", "Datadog",
    "ArgoCD", "FluxCD", "Spinnaker",
    "SonarQube", "Trivy", "OWASP ZAP",
    "Linux", "Bash", "Shell Scripting",
    "ECR", "ECS", "EKS", "Lambda", "S3", "EC2", "RDS",
]

# ── Shared resume field → value mapping (label fragment → extractor) ─────────
# Keys are lower-case substrings of form field labels.
RESUME_FIELD_MAP: dict[str, str] = {
    "first name": "first_name",
    "last name": "last_name",
    "full name": "name",
    "name": "name",
    "email": "email",
    "phone": "phone",
    "mobile": "phone",
    "years of experience": "total_years",
    "years": "total_years",
    "experience": "total_years",
    "city": "city",
    "location": "location",
}
