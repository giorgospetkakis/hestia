import os
import sys

from fastapi.testclient import TestClient

# Add the app directory to the path before importing main
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))
from main import app  # noqa: E402

client = TestClient(app)


def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_meals():
    response = client.get("/api/meals")
    assert response.status_code == 200
    assert "meals" in response.json()
