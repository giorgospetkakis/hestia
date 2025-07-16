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
    cd backend && . venv/bin/activate && pip install -r requirements.txt
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
    cd backend && . venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Start frontend development server
dev-frontend:
    @echo "🚀 Starting frontend development server..."
    cd frontend && flutter run

# Start both backend and frontend (requires tmux)
dev: dev-backend dev-frontend

# Start backend with hot reload
dev-backend-watch:
    @echo "👀 Starting backend with file watching..."
    cd backend && . venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000

# ===== TESTING =====

# Run all tests
test: test-backend test-frontend
    @echo "✅ All tests completed"

# Run backend tests
test-backend:
    @echo "🧪 Running backend tests..."
    cd backend && . venv/bin/activate && pytest -v

# Run backend tests with coverage
test-backend-coverage:
    @echo "🧪 Running backend tests with coverage..."
    cd backend && . venv/bin/activate && pytest --cov=app --cov-report=html --cov-report=term

# Run frontend tests
test-frontend:
    @echo "🧪 Running frontend tests..."
    cd frontend && flutter test

# Run frontend tests with coverage
test-frontend-coverage:
    @echo "🧪 Running frontend tests with coverage..."
    cd frontend && flutter test --coverage

# ===== CODE QUALITY =====

# Format all code
format: format-backend format-frontend
    @echo "✨ All code formatted"

# Format backend code
format-backend:
    @echo "✨ Formatting backend code..."
    cd backend && . venv/bin/activate && black app/ tests/
    cd backend && . venv/bin/activate && isort app/ tests/

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
    cd backend && . venv/bin/activate && flake8 app/ tests/
    cd backend && . venv/bin/activate && mypy app/

# Lint frontend code
lint-frontend:
    @echo "🔍 Linting frontend code..."
    cd frontend && flutter analyze

# Check code quality (format + lint)
check: format lint test
    @echo "✅ Code quality check completed"

# ===== BUILD & DEPLOYMENT =====

# Build for web
build-web:
    @echo "🏗️ Building for web..."
    cd frontend && flutter build web --release

# Build for deployment
build-deploy:
    @echo "🏗️ Building for deployment..."
    bash scripts/build.sh

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

# ===== UTILITIES =====

# Show project status
status:
    @echo "📊 Project Status:"
    @echo "Backend:"
    cd backend && . venv/bin/activate && python --version
    cd backend && . venv/bin/activate && pip list | grep -E "(fastapi|uvicorn|sqlalchemy)"
    @echo "Frontend:"
    cd frontend && flutter --version

# Update dependencies
update-deps: update-backend-deps update-frontend-deps
    @echo "📦 All dependencies updated"

# Update backend dependencies
update-backend-deps:
    @echo "📦 Updating backend dependencies..."
    cd backend && . venv/bin/activate && pip install --upgrade pip
    cd backend && . venv/bin/activate && pip install --upgrade -r requirements.txt

# Update frontend dependencies
update-frontend-deps:
    @echo "📦 Updating frontend dependencies..."
    cd frontend && flutter pub upgrade

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