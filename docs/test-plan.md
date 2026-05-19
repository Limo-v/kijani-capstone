# Capstone Test Plan

## 1. Fresh Setup Test
- Clone repository on a clean shell.
- Follow README setup steps exactly.
- Expected: staging and production overlays render and apply without undocumented manual steps.

## 2. Happy Path Pipeline Test
- Trigger Jenkins pipeline from main.
- Validate stage order: build/test -> deploy staging -> smoke test -> approval -> deploy production.
- Expected: production gate appears only after smoke test passes.

## 3. Failure Path Test
- Introduce deliberate fault (bad image tag or missing config value) in staging.
- Expected: smoke test fails or rollout blocks safely before production deployment.
- Apply fix and rerun.
- Expected: rollout and smoke test pass.

## 4. Governance Log Review Test
- Review docs/ai-governance-log.md entries.
- Expected: every entry includes all eight fields and field 7 is specific and non-empty.
