from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Hestia API",
    description="AI-powered nutrition assistant API",
    version="0.1.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to Hestia API", "status": "healthy"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "hestia-api"}

@app.get("/api/meals")
async def get_meals():
    return {
        "meals": [
            {
                "id": 1,
                "name": "Sample Breakfast",
                "type": "breakfast",
                "description": "A healthy start to your day"
            }
        ]
    } 