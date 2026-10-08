import json
from pathlib import Path
from jsonschema import validate, ValidationError

from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)

_SCHEMAS: dict = {}


def _load_schema(name: str) -> dict:
    if name not in _SCHEMAS:
        path = Config.SCHEMAS_DIR / name
        with open(path) as f:
            _SCHEMAS[name] = json.load(f)
    return _SCHEMAS[name]


def assert_schema(response_body: dict, schema_file: str):
    """Validate response_body against schema_file (filename in schemas/)."""
    schema = _load_schema(schema_file)
    try:
        validate(instance=response_body, schema=schema)
        log.info(f"Schema validation PASSED: {schema_file}")
    except ValidationError as e:
        log.error(f"Schema validation FAILED: {schema_file} | {e.message}")
        raise AssertionError(f"Schema mismatch [{schema_file}]: {e.message}")
