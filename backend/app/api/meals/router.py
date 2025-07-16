from fastapi import APIRouter, HTTPException
from typing import List, Optional
from pydantic import BaseModel

router = APIRouter(prefix="/api/meals", tags=["meals"])

class Meal(BaseModel):
    id: int
    name: str
    type: str
    description: str
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

@router.get("/", response_model=List[Meal])
async def get_meals():
    """Get all meals"""
    return [
        {
            "id": 1,
            "name": "Sample Breakfast",
            "type": "breakfast",
            "description": "A healthy start to your day",
            "calories": 350,
            "protein": 15.0,
            "carbs": 45.0,
            "fat": 12.0,
        },
        {
            "id": 2,
            "name": "Sample Lunch",
            "type": "lunch",
            "description": "A balanced midday meal",
            "calories": 550,
            "protein": 25.0,
            "carbs": 60.0,
            "fat": 18.0,
        }
    ]

@router.get("/{meal_id}", response_model=Meal)
async def get_meal(meal_id: int):
    """Get a specific meal by ID"""
    meals = [
        {
            "id": 1,
            "name": "Sample Breakfast",
            "type": "breakfast",
            "description": "A healthy start to your day",
            "calories": 350,
            "protein": 15.0,
            "carbs": 45.0,
            "fat": 12.0,
        },
        {
            "id": 2,
            "name": "Sample Lunch",
            "type": "lunch",
            "description": "A balanced midday meal",
            "calories": 550,
            "protein": 25.0,
            "carbs": 60.0,
            "fat": 18.0,
        }
    ]
    
    for meal in meals:
        if meal["id"] == meal_id:
            return meal
    
    raise HTTPException(status_code=404, detail="Meal not found")

@router.post("/", response_model=Meal)
async def create_meal(meal: Meal):
    """Create a new meal"""
    # In a real application, you would save this to a database
    return meal

@router.put("/{meal_id}", response_model=Meal)
async def update_meal(meal_id: int, meal: Meal):
    """Update an existing meal"""
    # In a real application, you would update this in a database
    meal.id = meal_id
    return meal

@router.delete("/{meal_id}")
async def delete_meal(meal_id: int):
    """Delete a meal"""
    # In a real application, you would delete this from a database
    return {"message": f"Meal {meal_id} deleted successfully"} 