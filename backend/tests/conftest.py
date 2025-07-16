import sys
from pathlib import Path

# Ensure backend directory is in sys.path before any imports
backend_dir = Path(__file__).parent.parent.resolve()
if str(backend_dir) not in sys.path:
    sys.path.insert(0, str(backend_dir))

import pytest  # noqa: E402
from fastapi.testclient import TestClient  # noqa: E402

from app.main import app  # noqa: E402


@pytest.fixture
def client():
    """Create a test client for the FastAPI app"""
    return TestClient(app)
