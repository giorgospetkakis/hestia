# Hestia – Your Daily Ritual for Nourishment & Rhythm

**Hestia** is an open-source, AI-powered nutrition assistant that helps you eat better, feel better, and live with rhythm — without calorie counting, guilt, or friction.

Inspired by the Greek goddess of the hearth, Hestia keeps your fire lit: planning meals, adapting to your health data, and gently guiding you toward consistency, joy, and self-care.

---

## Why Hestia?

Modern nutrition apps are built like spreadsheets and surveillance tools. Hestia is built like a good friend who:

- Knows what’s in your pantry
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

## Ethos & License

Hestia is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. That means:

- You’re free to use, modify, and distribute Hestia
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

## Contributing

Pull requests welcome! To get started:

```bash
git clone https://github.com/giorgospetkakis/hestia.git
cd hestia
# install backend/frontend dependencies
