# LAUNCH_GUIDE

## What runs locally right now

### Next.js web app

```powershell
cd web
npm run build
npm run start -- --hostname 127.0.0.1 --port 3000
```

Open:

- `http://127.0.0.1:3000/`
- `http://127.0.0.1:3000/login`
- `http://127.0.0.1:3000/dashboard`

Without Supabase env, dashboard opens in offline preview mode instead of crashing.

### Existing compiled Flutter web artifact

```powershell
cd build\web
python -m http.server 54123 --bind 127.0.0.1
```

Open:

- `http://127.0.0.1:54123/`

This serves the last built Flutter web artifact already present in the repo. It does not rebuild source.

## Required env variables

### Web app: `web\.env.local`

Start from:

```powershell
cd web
Copy-Item .env.local.example .env.local
```

Required values:

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
NEXT_PUBLIC_SITE_URL=http://127.0.0.1:3000
```

### Supabase Edge Functions secrets

These are required in the deployed Supabase project, not in public frontend env:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
AI provider keys
RevenueCat secret key
FCM/email provider secrets
```

### Flutter source app

Flutter source expects Supabase values via Dart defines:

```powershell
flutter run -d chrome `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## Backend reality

There is no standalone Node/Express/FastAPI backend in this repo.

The backend is:

- Supabase Postgres tables and RLS policies in `supabase\migrations`
- Supabase Edge Functions in `supabase\functions`

There is also no checked-in `supabase\config.toml`, so a local Supabase stack is not currently wired up from this checkout.

Hosted/deployed Supabase commands expected by the repo docs:

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
```

## Ports

- Next.js web app: `3000`
- Static Flutter web artifact preview: `54123`
- Supabase: hosted project URL, not a local repo server in the current checkout

## How to test the full app flow

### What I could test now

```powershell
curl.exe -I http://127.0.0.1:3000/
curl.exe -I http://127.0.0.1:3000/login
curl.exe -I http://127.0.0.1:3000/dashboard
curl.exe -I http://127.0.0.1:3000/dashboard/projects/new
curl.exe -I http://127.0.0.1:54123/
```

### Full real flow after adding Supabase env and deploying backend

1. Start the web app on port `3000`.
2. Open `/signup` and create an account.
3. Log in and open `/dashboard`.
4. Create a project from `/dashboard/projects/new`.
5. Browse `/dashboard/templates` and try `Use Template`.
6. Open the created project and confirm it appears in dashboard lists.
7. If admin data exists, open `/dashboard/admin/overview`.
8. Exercise Edge Functions from authenticated UI:
   - template use
   - admin actions
   - teams flows once connected

## Troubleshooting

- Dashboard shows offline preview:
  - `web\.env.local` is missing or incomplete.
- Login/signup/reset actions show configuration errors:
  - same root cause: missing `NEXT_PUBLIC_SUPABASE_URL` or `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
- Flutter commands fail:
  - Flutter SDK is not currently available on PATH in this environment.
  - `android\local.properties` references a missing SDK path.
- Supabase local commands fail:
  - `supabase` CLI is not installed on PATH here.
  - `supabase\config.toml` is not present.
