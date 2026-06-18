# APP_AUDIT_REPORT

## App capability

This repository contains three distinct surfaces:

1. Flutter app in `lib/` for mobile, desktop, and Flutter web.
2. Next.js web app in `web/` for marketing, auth, dashboard, admin, and template flows.
3. Supabase backend in `supabase/` with SQL migrations plus Edge Functions.

Current implemented capability found in code:

- Auth:
  - Web login, signup, forgot password UI against Supabase auth.
  - Flutter has auth client providers, but no end-user auth screens in the inspected routes.
- Projects:
  - Web dashboard can list and create projects in `app_projects`.
  - Flutter project repository can create and list projects.
- AI outputs:
  - Web can list generated outputs already stored in `generated_outputs`.
  - Flutter can view a generated output detail record.
  - I did not find active provider logic that generates AI/video output from this repo alone.
- Marketplace:
  - Web marketplace browsing, template detail, template use flow, admin template management.
  - Flutter marketplace browse/detail/favorites/review/admin screens exist.
- Teams:
  - Supabase schema and Edge Functions exist for teams, invites, roles, share/unshare.
  - Web teams page is read-only MVP.
  - Flutter has fuller teams screens and repositories.
- Export:
  - Flutter has PDF preview/export/share code and export logs.
- Analytics/admin:
  - Web admin dashboard pages and Supabase RPC-backed queries exist.
  - Flutter admin insights and usage screens exist.
- Marketing/support:
  - Public marketing pages, contact form, newsletter/waitlist form.

## Working features

- `web/` installs and builds successfully with `npm run build`.
- `web/` lint now runs successfully with `npm run lint`.
- Public Next.js pages respond correctly on `http://127.0.0.1:3000/`.
- `/login` and dashboard routes now load without crashing when Supabase env is missing.
- Existing compiled Flutter web artifact in `build/web` can be served as a static site.
- Supabase schema/functions are present and structured consistently for:
  - teams
  - marketplace
  - analytics
  - admin actions
  - export logs

## Broken features fixed

- Fixed web dashboard hard crash when `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` are missing.
- Added graceful no-config fallback for server-side dashboard/admin data queries.
- Added graceful client-side error handling for auth, project creation, template use, profile update, and admin actions when Supabase is not configured.
- Fixed the public navbar login button linking to `#` instead of `/login`.
- Added ESLint config so `npm run lint` is no longer interactive/broken.

## Remaining issues

- Full backend is not locally runnable yet:
  - there is no `supabase/config.toml`
  - there are no real Supabase project credentials in the repo
  - Edge Functions cannot be exercised end-to-end without a deployed Supabase project
- Flutter SDK is missing from this machine PATH, so I could not run `flutter analyze`, `flutter test`, or rebuild the Flutter app from source in this session.
- `android/local.properties` points to an old missing Flutter SDK path.
- Several features are scaffolded or placeholder-level:
  - web project detail: `Generate AI Plan` button is still TODO
  - web teams page: create team disabled, read-only MVP
  - Flutter upgrade screen is placeholder
  - store download links and support/legal contact values still include placeholder content
- I found no complete in-repo AI provider execution path for OpenAI/Gemini/Anthropic/video generation. The data model supports generated outputs, but the runtime generation flow is incomplete from this checkout alone.

## Duplicate / unfinished / caution areas

- `build/` contains generated artifacts checked into the repo, including a separate built web tree.
- `web/node_modules/` is present in the repo and should be treated as generated/vendor content.
- `build/web/` duplicates a large portion of the `web/` tree and should not be treated as source.
- README is still the default Flutter starter README and does not describe the real app.

## Launch readiness score

58/100

Reason:

- The web app is now runnable and stable as a local preview.
- The full product is not launch-ready because backend credentials/tooling are absent, Flutter source cannot currently be rebuilt on this machine, and some user-facing flows are still placeholders.
