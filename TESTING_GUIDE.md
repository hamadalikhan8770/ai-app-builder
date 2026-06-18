# TESTING_GUIDE

## Verified tests and checks

### Web install

```powershell
cd web
npm install
```

Status: Passed during the June 18, 2026 live environment verification pass.

### Web build

```powershell
cd web
npm run build
```

Status: Passed during the June 18, 2026 live environment verification pass.

### Web lint

```powershell
cd web
npm run lint
```

Status: Passed during the June 18, 2026 live environment verification pass.

### Web route smoke checks

```powershell
cd web
npm run start -- --hostname 127.0.0.1 --port 3010
curl.exe -I http://127.0.0.1:3010/
curl.exe -I http://127.0.0.1:3010/login
curl.exe -I http://127.0.0.1:3010/signup
curl.exe -I http://127.0.0.1:3010/dashboard
curl.exe -I http://127.0.0.1:3010/dashboard/projects/new
```

Status: Passed during the June 18, 2026 live environment verification pass.

### Web screenshot verification

Real screenshots were refreshed from the running app for:

- `docs/images/web/home.png`
- `docs/images/web/login.png`
- `docs/images/web/signup.png`
- `docs/images/web/dashboard.png`
- `docs/images/web/new-project.png`

### Existing built Flutter web artifact

```powershell
cd build\web
python -m http.server 54123 --bind 127.0.0.1
curl.exe -I http://127.0.0.1:54123/
```

Status: Passed as a static artifact smoke test.

## Not verified yet

- `flutter analyze`
- `flutter test`
- fresh Flutter source rebuild
- local Supabase startup
- authenticated end-to-end flows against a real Supabase project
- Edge Function invocation against deployed backend
- live mobile push, billing, email, or notification provider integration

## Suggested next verification steps

1. Restore a working Flutter SDK on PATH.
2. Run:
   ```powershell
   flutter pub get
   flutter analyze
   flutter test
   ```
3. Add real Supabase env values for the web app:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `NEXT_PUBLIC_SITE_URL`
4. Add live service credentials only if those features are being exercised:
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `OPENAI_API_KEY`
   - `ANTHROPIC_API_KEY`
   - `GEMINI_API_KEY`
   - `REVENUECAT_SECRET_KEY`
   - `FCM_SERVER_KEY`
   - `EMAIL_PROVIDER_API_KEY`
5. Deploy or connect a real Supabase project.
6. Re-test signup, login, project creation, template use, admin actions, and team flows.
