# PROJECT_SUMMARY

## What this project is

AI App Builder is a planning and workflow product for mobile app ideas. The codebase is organized around a Flutter client, a web dashboard, and a Supabase backend.

## What is implemented

- marketing site
- auth UI
- dashboard shell
- project creation and listing
- generated-output viewing
- marketplace browsing and template workflows
- teams schema and Edge Functions
- analytics and admin dashboards
- PDF export code on the Flutter side

## What was live-verified in this pass

- `web/npm install`
- `web/npm run build`
- `web/npm run lint`
- `web` local runtime on `http://127.0.0.1:3010`
- HTTP route checks for `/`, `/login`, `/signup`, `/dashboard`, and `/dashboard/projects/new`
- refreshed real web screenshots from the running app

## Screenshot status

- Web screenshots added from the real running Next.js app:
  - `docs/images/web/home.png`
  - `docs/images/web/login.png`
  - `docs/images/web/signup.png`
  - `docs/images/web/dashboard.png`
  - `docs/images/web/new-project.png`
- Flutter screenshots not captured: Flutter SDK not available on PATH
- Supabase screenshots not added because there is no backend UI surface to capture in this repository

## What is incomplete

- fully verified AI generation flow from prompt to persisted output
- fully verified backend wiring in a local environment
- fully verified Flutter rebuild and source test execution in this machine state
- some web flows still marked TODO or presented as MVP/placeholder states

## Best current interpretation

This repository is closest to a product that helps users move from app idea to structured app blueprint using templates, stored outputs, collaboration features, analytics, and export tools.

It is not verified yet as a complete production-ready code generator platform from this checkout alone.

## Live credential requirements

The web shell can run without live keys in preview mode, but the following real values are required for full end-to-end verification:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `NEXT_PUBLIC_SITE_URL`

Additional live credentials are required only for the corresponding service integrations:

- `SUPABASE_SERVICE_ROLE_KEY`
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GEMINI_API_KEY`
- `REVENUECAT_SECRET_KEY`
- `FCM_SERVER_KEY`
- `EMAIL_PROVIDER_API_KEY`
