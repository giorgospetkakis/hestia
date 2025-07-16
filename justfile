# Hestia Development Commands
# Run `just --help` to see all available commands

# Default recipe - show help
default:
    @just --list

# ===== SETUP & INSTALLATION =====

# Install all dependencies (backend + frontend)
install: install-backend install-frontend
    @echo "✅ All dependencies installed"

# Install backend dependencies
install-backend:
    @echo "📦 Installing backend dependencies..."
    cd backend && python3 -m venv venv
    cd backend && source venv/bin/activate && pip install -r requirements.txt
    @echo "✅ Backend dependencies installed"

# Install frontend dependencies
install-frontend:
    @echo "📦 Installing frontend dependencies..."
    cd frontend && flutter pub get
    @echo "✅ Frontend dependencies installed"

# Setup development environment
setup: install
    @echo "🚀 Development environment ready!"

# ===== DEVELOPMENT SERVERS =====

# Start backend development server
dev-backend:
    @echo "🚀 Starting backend development server..."
    cd backend && source venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Start frontend development server
dev-frontend:
    @echo "🚀 Starting frontend development server..."
    cd frontend && flutter run

# Start both backend and frontend (requires tmux)
dev: dev-backend dev-frontend

# Start backend with hot reload
dev-backend-watch:
    @echo "👀 Starting backend with file watching..."
    cd backend && source venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000

# ===== TESTING =====

# Run all tests
test: test-backend test-frontend
    @echo "✅ All tests completed"

# Run backend tests
test-backend:
    @echo "🧪 Running backend tests..."
    cd backend && source venv/bin/activate && pytest -v

# Run backend tests with coverage
test-backend-coverage:
    @echo "🧪 Running backend tests with coverage..."
    cd backend && source venv/bin/activate && pytest --cov=app --cov-report=html --cov-report=term

# Run frontend tests
test-frontend:
    @echo "🧪 Running frontend tests..."
    cd frontend && flutter test

# Run frontend tests with coverage
test-frontend-coverage:
    @echo "🧪 Running frontend tests with coverage..."
    cd frontend && flutter test --coverage

# Run integration tests
test-integration:
    @echo "🧪 Running integration tests..."
    cd tests && python -m pytest integration/ -v

# Run end-to-end tests
test-e2e:
    @echo "🧪 Running end-to-end tests..."
    cd tests && python -m pytest e2e/ -v

# ===== CODE QUALITY =====

# Format all code
format: format-backend format-frontend
    @echo "✨ All code formatted"

# Format backend code
format-backend:
    @echo "✨ Formatting backend code..."
    cd backend && source venv/bin/activate && black app/ tests/
    cd backend && source venv/bin/activate && isort app/ tests/

# Format frontend code
format-frontend:
    @echo "✨ Formatting frontend code..."
    cd frontend && dart format lib/ test/

# Lint all code
lint: lint-backend lint-frontend
    @echo "🔍 All code linted"

# Lint backend code
lint-backend:
    @echo "🔍 Linting backend code..."
    cd backend && source venv/bin/activate && flake8 app/ tests/
    cd backend && source venv/bin/activate && mypy app/

# Lint frontend code
lint-frontend:
    @echo "🔍 Linting frontend code..."
    cd frontend && flutter analyze

# Check code quality (format + lint)
check: format lint test
    @echo "✅ Code quality check completed"

# ===== DATABASE =====

# Initialize database
db-init:
    @echo "🗄️ Initializing database..."
    cd backend && source venv/bin/activate && alembic upgrade head

# Create new migration
db-migrate message:
    @echo "🗄️ Creating migration: {{message}}"
    cd backend && source venv/bin/activate && alembic revision --autogenerate -m "{{message}}"

# Apply migrations
db-upgrade:
    @echo "🗄️ Applying migrations..."
    cd backend && source venv/bin/activate && alembic upgrade head

# Rollback migration
db-downgrade:
    @echo "🗄️ Rolling back migration..."
    cd backend && source venv/bin/activate && alembic downgrade -1

# Reset database (DANGER!)
db-reset:
    @echo "⚠️ Resetting database..."
    cd backend && rm -f *.db
    cd backend && source venv/bin/activate && alembic upgrade head

# ===== BUILD & DEPLOYMENT =====

# Build all (backend + frontend)
build: build-backend build-frontend
    @echo "🏗️ All builds completed"

# Build backend
build-backend:
    @echo "🏗️ Building backend..."
    cd backend && source venv/bin/activate && python -m build

# Build frontend
build-frontend:
    @echo "🏗️ Building frontend..."
    cd frontend && flutter build apk --release
    cd frontend && flutter build ios --release --no-codesign

# Build for web
build-web:
    @echo "🏗️ Building for web..."
    cd frontend && flutter build web --release

# Build for deployment
build-deploy:
    @echo "🏗️ Building for deployment..."
    bash scripts/build.sh

# Docker build
docker-build:
    @echo "🐳 Building Docker images..."
    docker-compose build

# Docker development
docker-dev:
    @echo "🐳 Starting development environment with Docker..."
    docker-compose -f docker-compose.dev.yml up -d

# Docker production
docker-prod:
    @echo "🐳 Starting production environment with Docker..."
    docker-compose up -d

# Stop Docker containers
docker-stop:
    @echo "🐳 Stopping Docker containers..."
    docker-compose down

# ===== CLEANUP =====

# Clean all build artifacts
clean: clean-backend clean-frontend
    @echo "🧹 All cleanup completed"

# Clean backend
clean-backend:
    @echo "🧹 Cleaning backend..."
    cd backend && rm -rf build/ dist/ *.egg-info/ .pytest_cache/ .coverage htmlcov/
    cd backend && find . -type d -name __pycache__ -delete
    cd backend && find . -type f -name "*.pyc" -delete

# Clean frontend
clean-frontend:
    @echo "🧹 Cleaning frontend..."
    cd frontend && flutter clean
    cd frontend && rm -rf build/ .dart_tool/

# Clean Docker
clean-docker:
    @echo "🧹 Cleaning Docker..."
    docker-compose down -v --remove-orphans
    docker system prune -f

# ===== UTILITIES =====

# Show project status
status:
    @echo "📊 Project Status:"
    @echo "Backend:"
    cd backend && source venv/bin/activate && python --version
    cd backend && source venv/bin/activate && pip list | grep -E "(fastapi|uvicorn|sqlalchemy)"
    @echo "Frontend:"
    cd frontend && flutter --version
    @echo "Docker:"
    docker --version
    docker-compose --version

# Generate API documentation
docs-api:
    @echo "📚 Generating API documentation..."
    cd backend && source venv/bin/activate && python -c "import uvicorn; uvicorn.run('main:app', host='0.0.0.0', port=8000)" &
    @sleep 3
    curl http://localhost:8000/openapi.json > docs/api/openapi.json
    pkill -f uvicorn
    @echo "✅ API documentation generated at docs/api/openapi.json"

# Run security checks
security:
    @echo "🔒 Running security checks..."
    cd backend && source venv/bin/activate && bandit -r app/
    cd backend && source venv/bin/activate && safety check

# Update dependencies
update-deps: update-backend-deps update-frontend-deps
    @echo "📦 All dependencies updated"

# Update backend dependencies
update-backend-deps:
    @echo "📦 Updating backend dependencies..."
    cd backend && source venv/bin/activate && pip install --upgrade pip
    cd backend && source venv/bin/activate && pip install --upgrade -r requirements.txt

# Update frontend dependencies
update-frontend-deps:
    @echo "📦 Updating frontend dependencies..."
    cd frontend && flutter pub upgrade

# ===== DEVELOPMENT HELPERS =====

# Create new API endpoint
new-endpoint name:
    @echo "🆕 Creating new API endpoint: {{name}}"
    mkdir -p backend/app/api/v1/{{name}}
    touch backend/app/api/v1/{{name}}/__init__.py
    touch backend/app/api/v1/{{name}}/routes.py
    touch backend/app/api/v1/{{name}}/schemas.py
    @echo "✅ Endpoint structure created"

# Create new Flutter screen
new-screen name:
    @echo "🆕 Creating new Flutter screen: {{name}}"
    mkdir -p frontend/lib/screens/{{name}}
    touch frontend/lib/screens/{{name}}/{{name}}_screen.dart
    touch frontend/lib/screens/{{name}}/{{name}}_controller.dart
    @echo "✅ Screen structure created"

# Show logs
logs:
    @echo "📋 Showing recent logs..."
    tail -f backend/logs/app.log

# Health check
health:
    @echo "🏥 Running health checks..."
    curl -f http://localhost:8000/health || echo "❌ Backend not responding"
    curl -f http://localhost:3000 || echo "❌ Frontend not responding"

# ===== HELP =====

# Show this help
help:
    @just --list
    @echo ""
    @echo "For detailed help on any command, run: just <command> --help" 