# REAL_STATS

All numbers below were measured from the local repository during the upload pass. No stars, users, downloads, revenue, or other external popularity metrics are included.

## Repository facts

- Tracked files in the current repository: 379
- Focused app/doc files counted across `lib`, `web/app`, `web/components`, `web/lib`, `supabase`, `test`, `scripts`, `docs`: 248
- Total measured lines across the focused app/doc set: 8921

## Language breakdown by measured lines

- Dart: 6507
- TypeScript and TSX combined: 1004
- SQL: 802
- Markdown in the focused set before this upload-doc pass: 56
- CSS: 13
- Shell: 10

## File breakdown by extension in the broader reviewed set

- `.tsx`: 97
- `.dart`: 86
- `.png`: 35
- `.ts`: 33
- `.sql`: 8

## Frontend / backend counts

- Frontend files in `web/app`, `web/components`, `web/lib`: 110
- Backend files in `supabase`: 26
- Flutter source files in `lib`: Not separately computed here
- Test files in `test`: 1

## API surface

- Next.js API route files in `web/app`: 0
- Supabase Edge Functions: 17
- SQL migrations: 8

## Supabase Edge Functions found

- `accept-team-invite`
- `admin-disable-user`
- `admin-update-usage-limit`
- `admin-update-user-role`
- `create-team`
- `decline-team-invite`
- `generate-daily-usage-report`
- `invite-team-member`
- `moderate-template-review`
- `publish-marketplace-template`
- `remove-team-member`
- `send-admin-announcement`
- `share-project-with-team`
- `track-system-event`
- `unshare-project-from-team`
- `update-team-member-role`
- `use-marketplace-template`

## Verified build and test status

- Web build (`npm run build`): Passed
- Web lint (`npm run lint`): Passed
- Web runtime (`npm run start -- --hostname 127.0.0.1 --port 3010`): Passed
- Web route smoke checks: Passed for `/`, `/login`, `/signup`, `/dashboard`, `/dashboard/projects/new`
- Flutter source build from this environment: Not verified yet
- Flutter test suite execution from this environment: Not verified yet
- Local Supabase stack: Not verified yet
