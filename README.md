# AI App Builder

AI App Builder is a multi-surface app planning workspace built around Flutter, Next.js, and Supabase. The project combines a Flutter client, a separate web dashboard, and a Supabase backend with SQL migrations and Edge Functions for collaboration, template workflows, analytics, and export logging.

This repository is an existing project recovery and stabilization upload. It is not a greenfield starter and it is not presented as feature-complete.

## Verified project structure

- `lib/`: Flutter application code
- `web/`: Next.js web app
- `supabase/`: SQL migrations and Edge Functions
- `test/`: Flutter widget tests
- `scripts/`: helper scripts
- `docs/`: deployment notes

## Tech stack

- Flutter
- Dart
- Next.js 15
- React 19
- TypeScript
- Tailwind CSS
- Supabase
- PostgreSQL SQL migrations

## Verified features

- Public marketing website in Next.js
- Web login, signup, and password reset UI
- Web dashboard shell with offline-safe preview mode
- Project listing and project creation flow on the web client
- Marketplace browsing, template detail, and template-use wiring
- Admin dashboard pages and analytics query layer
- Team collaboration schema and Edge Function layer
- Flutter project, marketplace, team, analytics, admin, and PDF export surfaces in source
- Supabase Edge Functions for team, template, audit, and admin operations

## Current backend model

There is no standalone Express, FastAPI, or custom Node backend in this repository.

The backend is implemented through:

- Supabase database tables and RLS policies in `supabase/migrations`
- Supabase Edge Functions in `supabase/functions`

## Setup

### 1. Web app

```powershell
cd C:\Users\abasi\OneDrive\Desktop\my_first_app\web
Copy-Item .env.local.example .env.local
npm install
npm run build
npm run start -- --hostname 127.0.0.1 --port 3000
```

Required values in `web/.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
NEXT_PUBLIC_SITE_URL=http://127.0.0.1:3000
```

### 2. Flutter app

Flutter source is present, but Flutter rebuild/run was not verified in this environment because the local Flutter SDK was not available on PATH during this upload pass.

Expected command shape:

```powershell
flutter run `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

### 3. Supabase

Not verified yet for local stack startup from this repo because `supabase/config.toml` is not present in the current checkout.

Expected hosted/deployment workflow:

```powershell
supabase db push
supabase functions deploy create-team
supabase functions deploy invite-team-member
supabase functions deploy accept-team-invite
supabase functions deploy decline-team-invite
supabase functions deploy update-team-member-role
supabase functions deploy remove-team-member
supabase functions deploy share-project-with-team
supabase functions deploy unshare-project-from-team
supabase functions deploy use-marketplace-template
supabase functions deploy moderate-template-review
supabase functions deploy publish-marketplace-template
supabase functions deploy admin-update-user-role
supabase functions deploy admin-update-usage-limit
supabase functions deploy admin-disable-user
supabase functions deploy send-admin-announcement
supabase functions deploy track-system-event
supabase functions deploy generate-daily-usage-report
```

## Verified run status

- `web`: `npm run build` passed
- `web`: `npm run lint` passed
- `web`: local server boot on `http://127.0.0.1:3000` passed
- `web`: `/dashboard` no longer crashes when env is missing
- Flutter source rebuild: Not verified yet
- Supabase local stack: Not verified yet

## Known limitations

- Real Supabase credentials are not included in this repo
- `supabase/config.toml` is not present, so local Supabase orchestration is not verified
- Flutter SDK path in this environment was broken during inspection, so Flutter source build/test is not verified yet
- Some flows are scaffolded rather than finished, including:
  - web project detail AI generation action
  - parts of the team workflow on the web client
  - placeholder upgrade/download/store content
- Existing generated output viewing is implemented, but a fully verified in-repo AI generation provider pipeline is not confirmed yet

## Repository docs

- [SETUP_GUIDE.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\SETUP_GUIDE.md)
- [TESTING_GUIDE.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\TESTING_GUIDE.md)
- [PROJECT_SUMMARY.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\PROJECT_SUMMARY.md)
- [REAL_STATS.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\REAL_STATS.md)
- [APP_AUDIT_REPORT.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\APP_AUDIT_REPORT.md)
- [LAUNCH_GUIDE.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\LAUNCH_GUIDE.md)
- [REPAIR_LOG.md](C:\Users\abasi\OneDrive\Desktop\my_first_app\REPAIR_LOG.md)

## Roadmap

- Restore verified Flutter source builds in a clean local SDK setup
- Add local Supabase project config and documented local backend startup
- Complete end-to-end authenticated flows for projects, templates, teams, and admin actions
- Connect or document the intended AI generation pipeline explicitly
- Replace placeholder product/legal/store copy with release-ready content
