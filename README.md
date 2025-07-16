# Hestia – Your Daily Ritual for Nourishment & Rhythm

<!-- 
Workflow badges will work once the repository is created and workflows have run:
![Backend Tests](https://github.com/[username]/hestia/workflows/Backend%20Tests/badge.svg)
![Frontend Tests](https://github.com/[username]/hestia/workflows/Frontend%20Tests/badge.svg)
![Code Quality](https://github.com/[username]/hestia/workflows/Code%20Quality/badge.svg)
![Build](https://github.com/[username]/hestia/workflows/Build/badge.svg)
-->

**Hestia** is an open-source, AI-powered nutrition assistant that helps you eat better, feel better, and live with rhythm — without calorie counting, guilt, or friction.

Inspired by the Greek goddess of the hearth, Hestia keeps your fire lit: planning meals, adapting to your health data, and gently guiding you toward consistency, joy, and self-care.

---

## Why Hestia?

Modern nutrition apps are built like spreadsheets and surveillance tools. Hestia is built like a good friend who:

- Knows what's in your pantry
- Understands your training, sleep, and schedule
- Gently nudges you with daily plans and seasonal recipes
- Helps you prep ahead, adapt dynamically, and reflect with kindness

No calories. No shame. No endless input boxes. Just care, rhythm, and delicious structure.

---

## Features (v0.1 Alpha)

| Feature | Status |
|--------|--------|
| Personalized daily meal plan | 🔄 In progress |
| Integration with Health Connect / Garmin | 🔄 In progress |
| Weekly meal prep and grocery list | 🔄 In progress |
| Adaptive plan adjustment based on sleep, exercise & check-ins | 🔄 In progress |
| Telegram bot + email delivery | 🔄 In progress |
| Monthly review + pattern analysis | 🔄 In progress |
| Social prompts (potlucks, challenges, communal meals) | Future |

---

## Tech Stack

- **Frontend**: Flutter
- **Backend**: FastAPI + LLM-powered planning engine
- **Storage**: SQLite (local) / Supabase (cloud)
- **Integrations**: Health Connect, Garmin, Telegram, Todoist
- **Scheduler**: Celery + Redis (for meal plan delivery)
- **License**: [AGPL-3.0](./LICENSE)

---

## Quick Start

### Prerequisites

- **Python 3.11+** for backend
- **Flutter 3.16+** for frontend
- **Just** (task runner) - [Installation guide](https://just.systems/)
- **Git**

### Local Development Setup

#### Backend Setup

```bash
# Install backend dependencies
just install-backend

# Create and edit backend/.env manually as needed

# Initialize database
just db-init

# Run the development server
just dev-backend
```

#### Frontend Setup

```bash
# Install frontend dependencies
just install-frontend

# Create and edit frontend/.env manually as needed

# Run the app
just dev-frontend
```


### Backend Only (API Development)

```bash
# Install backend dependencies
just install-backend

# Create and edit backend/.env manually as needed

# Initialize database
just db-init

# Start backend server
just dev-backend
```

---

## Configuration

### Backend Environment Variables

Create and edit `backend/.env` with:

```env
# Database
DATABASE_URL=sqlite:///./hestia.db
# or for PostgreSQL: postgresql://user:pass@localhost/hestia

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# LLM Integration
OPENAI_API_KEY=your-openai-api-key
# or ANTHROPIC_API_KEY=your-anthropic-key

# External Integrations
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
GARMIN_CLIENT_ID=your-garmin-client-id
GARMIN_CLIENT_SECRET=your-garmin-secret
HEALTH_CONNECT_CLIENT_ID=your-health-connect-id

# Redis (for Celery)
REDIS_URL=redis://localhost:6379

# Optional: Supabase
SUPABASE_URL=your-supabase-url
SUPABASE_KEY=your-supabase-anon-key
```

### Frontend Environment Variables

Create and edit `frontend/.env` with:

```env
# Backend API
API_BASE_URL=http://localhost:8000
# or for production: https://your-api-domain.com

# Health Connect (Android)
HEALTH_CONNECT_PACKAGE_NAME=com.example.hestia
```

---

## Development

### Project Structure

```
hestia/
├── backend/                 # FastAPI backend
│   ├── app/
│   │   ├── api/            # API endpoints
│   │   ├── core/           # Core configuration
│   │   ├── models/         # Database models
│   │   ├── services/       # Business logic
│   │   └── integrations/   # External services
│   └── tests/              # Backend tests
├── frontend/               # Flutter app
│   ├── lib/
│   │   ├── screens/        # UI screens
│   │   ├── services/       # API clients
│   │   └── widgets/        # UI components
│   └── test/               # Frontend tests
├── docs/                   # Documentation
└── scripts/                # Deployment scripts
```

### Common Development Tasks

```bash
# Run all tests
just test

# Run backend tests only
just test-backend

# Run frontend tests only
just test-frontend

# Format code
just format

# Lint code
just lint

# Complete code quality check
just check

# Database migrations
just db-migrate "description"
just db-upgrade
```

### Available Commands

The project uses [Just](https://just.systems/) as a task runner. Run `just --help` to see all available commands:

**Setup & Installation:**
- `just setup` - Complete development environment setup
- `just install` - Install all dependencies
- `just setup-env` - Copy environment files

**Development:**
- `just dev-backend` - Start backend server with hot reload
- `just dev-frontend` - Start Flutter development server
- `just dev` - Start both (requires tmux)

**Testing:**
- `just test` - Run all tests
- `just test-backend` / `just test-frontend` - Platform-specific tests
- `just test-backend-coverage` - With coverage reports

**Code Quality:**
- `just format` - Format all code
- `just lint` - Lint all code
- `just check` - Complete quality check (format + lint + test)

**Database:**
- `just db-init` - Initialize database
- `just db-migrate "message"` - Create new migration
- `just db-upgrade` / `just db-downgrade` - Apply/rollback migrations

**Build & Deployment:**
- `just build-web` - Build frontend for web
- `just build-deploy` - Build for deployment
- `just deploy` - Production deployment

**Utilities:**
- `just status` - Show project status
- `just health` - Health checks
- `just logs` - View logs
- `just clean` - Clean build artifacts

### API Development

The backend provides a comprehensive API with automatic documentation:

- **Interactive API docs**: http://localhost:8000/docs
- **ReDoc documentation**: http://localhost:8000/redoc
- **OpenAPI schema**: http://localhost:8000/openapi.json

### Health Data Integration

Hestia integrates with multiple health platforms:

- **Health Connect** (Android): Sleep, activity, nutrition data
- **Garmin**: Training load, sleep, activity metrics
- **Todoist**: Task integration for meal prep

See `docs/integrations/` for detailed setup guides.

---

## Deployment

### Local Development
```bash
# Build for local testing
just build-web
```

### Railway Deployment
The project is configured for automatic deployment on Railway:

1. **Connect to Railway**: 
   - Install Railway CLI: `npm i -g @railway/cli`
   - Login: `railway login`
   - Link project: `railway link`

2. **Deploy**: 
   ```bash
   railway up
   ```

3. **Automatic Deployment**: Railway will automatically:
   - Install Python dependencies
   - Build Flutter web app
   - Start FastAPI server with static file serving
   - Deploy everything as a single service

### Environment-Specific Configs

- `railway.json` - Railway deployment configuration
- `scripts/railway-start.sh` - Railway start script
- `backend/app/main.py` - FastAPI app with static file serving

### CI/CD Status

Once the repository is created on GitHub and the workflows have run at least once, you can uncomment the workflow badges at the top of this README. The badges will show the status of:

- **Backend Tests** - Python unit tests and coverage
- **Frontend Tests** - Flutter unit tests and coverage  
- **Code Quality** - Formatting, linting, and security checks
- **Build** - Backend and frontend build status
- **Deploy to Railway** - Production deployment status

---

## Contributing

Pull requests welcome! To get started:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Run the test suite: `just test`
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Development Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Use conventional commit messages
- Ensure all tests pass before submitting
- Use `just check` to verify code quality before committing

---

## Ethos & License

Hestia is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. That means:

- You're free to use, modify, and distribute Hestia
- If you run it as a service or modify it for production use, you must share your source code
- Contributions are welcome and encouraged — this is a communal hearth, not a solo kitchen

We believe nutrition should be:

- A right, not a product
- A shared ritual, not a solitary grind
- Adaptive, joyful, and dignified

---

## Roadmap

- [ ] Micro and macronutrient balance engine
- [ ] Seasonal food database
- [ ] Pantry-aware meal planning
- [ ] Mood and energy tracking (optional)
- [ ] Visual charts + narrative progress summaries
- [ ] Community-sourced recipe sets

---

## Support

- **Documentation**: Check the `docs/` directory
- **Issues**: Report bugs and feature requests on GitHub
- **Discussions**: Join the community discussions
- **Email**: For private matters, contact the maintainers

---

## Acknowledgments

Thanks to the open-source community for the amazing tools that make this possible
