# Screenshot Capture Guide

This guide gives exact commands and UI checkpoints to capture all evidence screenshots in docs/evidence/screenshot-index.md.

## 1. Open terminal windows
Use four terminal windows from repository root:

- Terminal 1: Git trigger and prep
- Terminal 2: Staging live monitor
- Terminal 3: Production and runtime checks
- Terminal 4: Fault injection and recovery

## 2. One-time preparation
Run in Terminal 1:

```bash
cd /home/kibet/Documents/Moringa/devops/ips/kijani-capstone
mkdir -p docs/evidence/screenshots
kubectl config current-context
git pull origin main
```

Run in Terminal 2:

```bash
cd /home/kibet/Documents/Moringa/devops/ips/kijani-capstone
watch -n 5 "kubectl -n kijani-staging get deploy,pods -l app=kk-payments"
```

Run in Terminal 3:

```bash
cd /home/kibet/Documents/Moringa/devops/ips/kijani-capstone
watch -n 5 "kubectl -n kijani-production get deploy,pods -l app=kk-payments"
```

## 3. Trigger pipeline for screenshots 01 to 07 and 11
Run in Terminal 1:

```bash
cd /home/kibet/Documents/Moringa/devops/ips/kijani-capstone
git commit --allow-empty -m "chore: trigger capstone evidence pipeline"
git push origin main
```

Then use UI checkpoints:

- GitHub UI: open repo commits or Actions/Webhook delivery view after push.
- Jenkins UI: open the pipeline run page and stage view for the same commit.

## 4. Capture map for each screenshot
Use this exact sequence.

| Screenshot | Capture from | What to show | Command to run |
|---|---|---|---|
| 01-pipeline-trigger.png | GitHub UI | New pushed commit that triggers CI | Terminal 1: git commit --allow-empty -m "chore: trigger capstone evidence pipeline" && git push origin main |
| 02-pipeline-started.png | Jenkins UI | Pipeline run started with early stages visible | No extra command. Refresh Jenkins run page. |
| 03-staging-deploy-success.png | Jenkins UI plus Terminal 2 | Deploy Staging stage success, staging resources healthy | Terminal 2 is already running watch command |
| 04-staging-smoke-test-success.png | Jenkins UI | Staging Smoke Test stage passed | No extra command. Open stage log if needed. |
| 05-approval-gate-visible.png | Jenkins UI | Manual approval input step waiting | No extra command. Wait for gate and capture. |
| 06-production-deploy-success.png | Jenkins UI plus Terminal 3 | Deploy Production stage success, production resources healthy | Terminal 3 is already running watch command |
| 07-runtime-verification-healthy.png | Terminal 3 | Healthy runtime verification in production namespace | Stop watch with Ctrl+C, then run: kubectl -n kijani-production rollout status deployment/kk-payments --timeout=180s && kubectl -n kijani-production get pods -l app=kk-payments |
| 08-fault-introduced.png | Terminal 4 | Deliberate bad image applied in staging | kubectl -n kijani-staging set image deployment/kk-payments kk-payments=ghcr.io/example/kk-payments:does-not-exist |
| 09-fault-handled-safely.png | Jenkins UI plus Terminal 4 | Staging fails safely and production is not deployed | kubectl -n kijani-staging rollout status deployment/kk-payments --timeout=120s |
| 10-recovery-success.png | Terminal 4 plus Jenkins UI | Staging restored and healthy after recovery | kubectl kustomize --load-restrictor LoadRestrictionsNone k8s/overlays/staging \| kubectl apply -f - && kubectl -n kijani-staging rollout status deployment/kk-payments --timeout=180s |
| 11-final-healthy-state.png | Jenkins UI plus Terminal 3 | Final successful end state after rerun | Terminal 1: git commit --allow-empty -m "chore: trigger post-recovery verification run" && git push origin main |
| 12-governance-log-proof.png | Editor UI or GitHub UI | ai-governance-log entry visible with complete fields | No extra command. Open docs/ai-governance-log.md and capture entry. |

## 5. Optional rerun command block
If you need a clean rerun after recovery, use Terminal 1:

```bash
cd /home/kibet/Documents/Moringa/devops/ips/kijani-capstone
git commit --allow-empty -m "chore: rerun pipeline for evidence completeness"
git push origin main
```

## 6. Fill screenshot index after capture
After each screenshot is taken and saved in docs/evidence/screenshots, update docs/evidence/screenshot-index.md:

- Replace PENDING with DONE
- Add relative path like docs/evidence/screenshots/01-pipeline-trigger.png
