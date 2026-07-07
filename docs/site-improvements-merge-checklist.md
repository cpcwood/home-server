# Site Improvements — Merge & Deploy Checklist

This branch bundles UI work (dark mode, buttons, links, gallery scroll-load), an
admin analytics dashboard, contact-messages view, **TOTP 2FA replacing Twilio**,
and **outbound email moving to AWS SES**. Two of those need out-of-band steps
before or during deploy — this is the ordered checklist. Full detail lives in the
`README.md` runbooks; this is the sequence.

Branch state: full suite green (rspec, jest, rubocop, lint).

## 1. Before merge
- [ ] CI green on the PR
- [ ] PR reviewed

## 2. Secrets — populate BEFORE deploy (required)
2FA adds Active Record encryption. Three new SSM keys must exist or every
`otp_secret` read/write raises:
- [ ] Generate: `./tasks rails db:encryption:init` (copy the three values)
- [ ] Set in SSM: `scripts/populate-parameter-store.sh app`, filling
      `AR_ENCRYPTION_PRIMARY_KEY`, `AR_ENCRYPTION_DETERMINISTIC_KEY`,
      `AR_ENCRYPTION_KEY_DERIVATION_SALT`

Twilio keys are gone. SES SMTP creds are Terraform-generated (bundle `…/email`),
not entered here.

## 3. SES email cutover (gated — do NOT ship in one shot)
Email flips from the old SMTP provider to SES. Order matters — the Helm SMTP
switch must be last:
- [ ] `terraform apply` — creates the SES identity, DKIM, SMTP user, `…/email` SSM param
- [ ] Add DNS at the host: TXT `_amazonses.cpcwood.com` = `ses_domain_verification_token`;
      three DKIM CNAMEs from `ses_dkim_tokens` (`<token>._domainkey.cpcwood.com` → `<token>.dkim.amazonses.com`)
- [ ] Wait until the identity shows **Verified** in the SES console (async, lags DNS)
- [ ] Request SES **production access** (separate async AWS approval, ~24h; sandbox delivers only to verified addresses)
- [ ] Deploy the Helm change (repoints `EMAIL_SMTP_*` at SES)
- [ ] Verify: contact-form mail works once Verified; run the external password-reset test only after Verified **and** production access granted

## 4. Migrations (automatic)
The pre-upgrade migrate job adds `otp_secret` / `otp_consumed_timestep` and drops
`mobile_number`. No manual step (the Postgres volume is covered by Velero backups).

## 5. Post-deploy
- [ ] Log in — 2FA is not enforced yet (password-only, with an "enable 2FA" nudge)
- [ ] Enroll 2FA: User Settings → Set up 2FA (scan QR, enter current password + code)
- [ ] Smoke test: dark-mode toggle, `/admin/analytics`, `/admin/notifications`, gallery scroll-load

## 6. Deferred follow-ups (non-blocking)
- Point `Rack::Attack.cache.store` at Redis so the `/2fa` throttle counts
  cluster-wide — production `cache_store` is commented, so counters are per-pod
  today (pre-existing; also affects the old global throttle).
- Optional: theme-reactive / dark-tuned chart palette on the analytics dashboard.

## Safety notes
- An admin who hasn't enrolled 2FA can still log in — deploy does not lock anyone out.
- A missing `…/email` SSM param does not crashloop pods: `EMAIL_*` env vars are
  read lazily and nil-safe, and External Secrets fails closed (the existing
  secret is retained). Worst case from an out-of-order deploy is email silently
  failing until `terraform apply` runs — not an outage.
