"""
runner/run_auth.py
------------------
Runner file — the ONLY job of this file is:
  1. point to the feature file
  2. import the step definitions so pytest-bdd can find them

pytest discovers this file, scenarios() registers all scenarios in the
feature file as individual test functions, and step definitions are
resolved from the imported steps module.

To run only auth tests:
    pytest tests/auth/runner/
"""

from pytest_bdd import scenarios
from pathlib import Path

# Import step definitions — must be imported here so pytest-bdd resolves them
from tests.auth.steps.auth_steps import *  # noqa: F401, F403

# Point to feature file — all scenarios inside are auto-registered as tests
FEATURE = str(Path(__file__).resolve().parent.parent / "features" / "auth.feature")
scenarios(FEATURE)
