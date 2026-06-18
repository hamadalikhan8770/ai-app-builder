# SETUP_GUIDE

## Overview

This project has three parts:

- Flutter app source in `lib/`
- Next.js web app in `web/`
- Supabase backend code in `supabase/`

## Web app setup

```powershell
cd C:\Users\abasi\OneDrive\Desktop\my_first_app\web
Copy-Item .env.local.example .env.local
npm install
npm run build
npm run start -- --hostname 127.0.0.1 --port 3000
```

Required env values:

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
NEXT_PUBLIC_SITE_URL=http://127.0.0.1:3000
```

## Flutter app setup

Not verified yet in this environment because the Flutter SDK was not available on PATH during the upload pass.

Expected prerequisites:

- Flutter SDK installed and available on PATH
- Android SDK configured for Android builds

Expected run shape:

```powershell
flutter pub get
flutter run `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## Supabase setup

Not verified yet for local orchestration because `supabase/config.toml` is not present in the repository.

The codebase expects:

- database migrations in `supabase/migrations`
- Edge Functions in `supabase/functions`

Hosted deployment pattern:

```powershell
supabase db push
supabase functions deploy <function-name>
```

## Local files that should stay private

- `.env`
- `.env.local`
- `android/local.properties`
- any service-role keys, provider keys, or tokens

## Notes

- The web app now renders an offline-safe preview if Supabase env is missing.
- Real backend functionality requires a real Supabase project and credentials.
