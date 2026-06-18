# Production Deployment Checklist

## Web / Vercel
- Project root: `web`
- Build command: `npm run build`
- Env vars:
  - `NEXT_PUBLIC_SUPABASE_URL`
  - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  - `NEXT_PUBLIC_SITE_URL`
- Never add service-role keys to Vercel public env vars.

## Supabase
- Run `supabase db push`.
- Deploy functions:
  - create-team
  - invite-team-member
  - accept-team-invite
  - decline-team-invite
  - update-team-member-role
  - remove-team-member
  - share-project-with-team
  - unshare-project-from-team
  - use-marketplace-template
  - moderate-template-review
  - publish-marketplace-template
  - admin-update-user-role
  - admin-update-usage-limit
  - admin-disable-user
  - send-admin-announcement
- Set function secrets only in Supabase:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
  - `SUPABASE_SERVICE_ROLE_KEY`
  - AI provider keys
  - RevenueCat secret key
  - FCM/email provider secrets

## Flutter Android
- Set app id/package.
- Configure release signing keystore.
- Run `flutter build appbundle --release`.
- Upload AAB to Google Play Console.
- Complete Data Safety, screenshots, privacy policy, subscription products.

## Flutter iOS
- Set bundle identifier/team in Xcode.
- Configure App Store Connect app and IAP products.
- Run archive from Xcode or `flutter build ipa --release`.
- Upload to App Store Connect.
- Complete privacy nutrition labels, screenshots, review notes.

## RevenueCat
- Configure iOS/Android products and entitlements.
- Use public SDK keys in Flutter only.
- Keep secret key in Supabase Edge Function secrets only.

## Firebase / Notifications
- Configure FCM/APNs.
- Upload APNs key/cert if needed.
- Verify notification permissions and test device tokens.

## Final QA
- Test auth, projects, AI generation, templates, teams, PDF export, notifications, subscriptions, analytics, admin web dashboard.
