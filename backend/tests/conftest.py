import os
import sys
import pytest
from pathlib import Path

# Add the backend directory to the Python path
backend_dir = Path(__file__).parent.parent
sys.path.insert(0, str(backend_dir))

# Import the FastAPI app for testing
from app.main import app
from fastapi.testclient import TestClient

@pytest.fixture
def client():
    """Create a test client for the FastAPI app"""
    return TestClient(app) 