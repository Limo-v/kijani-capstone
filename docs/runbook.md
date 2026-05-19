# Capstone Runbook (Track A)

## Goal
Deploy kk-payments through staging first, validate smoke test, then promote to production only after approval.

## Preconditions
- Access to Jenkins with this repository configured.
- kubectl context points to target cluster.
- Namespace permissions for kijani-staging and kijani-production.
- Any required image pull credentials are already present.

## Deploy Sequence
1. Trigger Jenkins from main.
2. Confirm staging deploy stage succeeds.
3. Confirm smoke test stage passes.
4. Approve promotion when gate appears.
5. Confirm production deploy stage succeeds.

## Smoke Validation Commands
- kubectl -n kijani-staging rollout status deployment/kk-payments --timeout=180s
- kubectl -n kijani-staging get pods -l app=kk-payments

## Fault Injection and Recovery
- Inject fault by setting an invalid image tag in staging overlay.
- Re-run pipeline and verify safe stop before production.
- Restore valid tag and re-run pipeline.

## Rollback
- kubectl -n kijani-staging rollout undo deployment/kk-payments
- kubectl -n kijani-production rollout undo deployment/kk-payments

## Evidence Reminder
Capture screenshots in the numbered order defined in docs/evidence/screenshot-index.md.
