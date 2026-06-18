# TESTING_GUIDE

## Verified tests and checks

### Web build

```powershell
cd C:\Users\abasi\OneDrive\Desktop\my_first_app\web
npm run build
```

Status: Passed during this upload pass.

### Web lint

```powershell
cd C:\Users\abasi\OneDrive\Desktop\my_first_app\web
npm run lint
```

Status: Passed during this upload pass.

### Web route smoke checks

```powershell
curl.exe -I http://127.0.0.1:3000/
curl.exe -I http://127.0.0.1:3000/login
curl.exe -I http://127.0.0.1:3000/dashboard
curl.exe -I http://127.0.0.1:3000/dashboard/projects/new
```

Status: Passed during this upload pass.

### Existing built Flutter web artifact

```powershell
cd C:\Users\abasi\OneDrive\Desktop\my_first_app\build\web
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

## Suggested next verification steps

1. Restore a working Flutter SDK on PATH.
2. Run:
   ```powershell
   flutter pub get
   flutter analyze
   flutter test
   ```
3. Add real Supabase env values for the web app.
4. Deploy or connect a real Supabase project.
5. Re-test signup, login, project creation, template use, admin actions, and team flows.
