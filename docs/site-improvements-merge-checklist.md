# Site Improvements — Merge & Deploy Checklist

This branch bundles UI work (dark mode, buttons, links, gallery scroll-load), an
admin analytics dashboard, contact-messages view, **TOTP 2FA replacing Twilio**,
and **outbound email moving to AWS SES**. Full detail lives in the `README.md`
runbooks; this is the sequence.

Merging to `main` runs `terraform apply` and the Helm deploy in the same CI run,
so everything the deploy depends on has to exist **before** the merge.

## 1. Before merge — secrets (required)
2FA adds Active Record encryption. Three new SSM keys must exist or every
`otp_secret` read/write raises:
- [ ] Generate: `./tasks rails db:encryption:init` (copy the three values)
- [ ] Set in SSM: `scripts/populate-parameter-store.sh app`, filling
      `AR_ENCRYPTION_PRIMARY_KEY`, `AR_ENCRYPTION_DETERMINISTIC_KEY`,
      `AR_ENCRYPTION_KEY_DERIVATION_SALT`
- [ ] Leave the Twilio keys in SSM until the deploy is stable (see Rollback)

## 2. Before merge — SES and the CI role (required)
This branch adds SES statements to the CI role's own policy. CI can't change
its own role (`DenySelfModification` in `iam.tf`), so the first apply has to run
locally:
- [ ] From this branch: `./scripts/bootstrap.sh` — applies the CI role policy and
      creates the SES identity, DKIM, SMTP user and `…/email` SSM param
- [ ] Add DNS at the host: TXT `_amazonses.cpcwood.com` = `ses_domain_verification_token`;
      three DKIM CNAMEs from `ses_dkim_tokens` (`<token>._domainkey.cpcwood.com` → `<token>.dkim.amazonses.com`).
      Leave the existing `_dmarc` record (`p=reject`) as it is — SES mail passes it via DKIM
- [ ] Wait until the identity shows **Verified** in the SES console (async, lags DNS)
- [ ] Request SES **production access** and wait for approval (~24h). Until then SES
      only delivers to verified addresses, so password-reset and 2FA-enrollment
      emails to the admin address bounce

## 3. Merge
- [ ] CI green on the PR, PR reviewed
- [ ] Merge — CI's `terraform` job is now a no-op for the IAM/SES resources, and
      `deploy` repoints `EMAIL_SMTP_*` at SES

The pre-upgrade migrate job adds `otp_secret` / `otp_consumed_timestep` /
`failed_otp_attempts` / `otp_locked_until`. It does **not** drop `mobile_number`
(see Rollback).

## 4. Post-deploy
- [ ] Log in **immediately after deploy** — until 2FA is enrolled, a password login
      can only reach the 2FA setup page
- [ ] Enroll 2FA on the setup page (scan QR, enter current password + code); confirm
      the "Two Factor Authentication Updated" email arrives
- [ ] Send a contact-form message and a password reset; both should arrive via SES
- [ ] Smoke test: dark-mode toggle, `/admin/analytics`, `/admin/notifications`, gallery scroll-load

## Rollback
The new migrations are additive and `mobile_number` is kept (`ignored_columns` on
`User`), so rolling back to the previous image restores SMS 2FA as long as the
Twilio keys are still in SSM. Once this release is stable, a follow-up should drop
`mobile_number` and remove the Twilio keys.

## Deferred follow-ups (non-blocking)
- Drop `users.mobile_number` and the Twilio SSM keys (after the release is stable).
- Point `Rack::Attack.cache.store` at Redis so throttles count cluster-wide —
  production `cache_store` is commented, so counters are per-pod (replicaCount is 1 today).
- Optional: theme-reactive / dark-tuned chart palette on the analytics dashboard.

## Safety notes
- An admin who hasn't enrolled 2FA can still log in, but only to enroll — deploy does
  not lock anyone out. Whoever holds the password can enroll first, so enroll straight
  after deploy; the enrollment email flags it if someone else does.
- The app ExternalSecret pulls the `app`, `db`, `app-storage` and `email` bundles
  together. If any of them is missing (e.g. `…/email` before the bootstrap apply), the
  whole secret stops syncing: the existing secret is retained, so pods keep running on
  the old values — the `AR_ENCRYPTION_*` keys never arrive (2FA enrollment raises) and
  SMTP keeps the old provider's credentials against the new SES host. Section 2 before
  merge avoids this.
