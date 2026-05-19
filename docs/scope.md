# Capstone Scope Document

## Problem Statement
KijaniKiosk lacks a safe staging-first deployment path for kk-payments. Direct production-oriented deployment increases risk because failed rollout conditions can be detected too late.

## Track
Track A (Infrastructure-First)

## What I Will Build
- A staging namespace separated from production namespace.
- A Jenkins pipeline that deploys to staging, runs smoke checks, then pauses for approval before production.
- Environment-specific kk-payments ConfigMap values using the same deployment manifest logic.
- A committed monitoring signal for kk-payments health in staging.
- Capstone documentation and governance artifacts for reproducibility and review.

## What Is Out of Scope
- Full production cloud hardening across all AWS services due capstone time limits.
- End-user feature development for kk-api or kk-payments application code.

## Success Criteria
1. Merge-triggered pipeline deploys kk-payments to staging and smoke test passes before approval appears.
2. Production deployment only occurs after manual approval in Jenkins.
3. ConfigMap values differ between staging and production for DB_HOST and receipts bucket configuration.

## Architecture Diagram
Add architecture image as docs/architecture.png and reference it in README.
