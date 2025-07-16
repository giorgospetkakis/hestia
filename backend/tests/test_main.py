def test_root(client):
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_meals(client):
    response = client.get("/api/meals")
    assert response.status_code == 200
    meals = response.json()
    assert isinstance(meals, list)
    assert len(meals) > 0
    assert "name" in meals[0]
