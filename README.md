# Kijani Capstone

## What this is
Kijani Capstone is a Track A infrastructure-first DevOps project that deploys kk-payments through a staging-first CI/CD flow, validates health in staging, and promotes to production only after explicit approval.

## Architecture
Architecture diagram: docs/architecture.png

Components summary:
- Terraform provisions infrastructure resources required for the staging and production workflow.
- Ansible applies environment configuration and operational hardening.
- Kubernetes manifests deploy kk-payments with probes, limits, and configuration separation.
- Jenkins orchestrates build, staging deploy, smoke test, approval gate, and production deploy.
- Monitoring rules capture service health signals for kk-payments.

## Prerequisites
- Git 2.34+
- Jenkins with Pipeline plugin
- kubectl 1.27+
- Kubernetes cluster access for namespaces kijani-staging and kijani-production
- Terraform 1.5+
- Ansible 2.14+
- AWS CLI v2 (if provisioning against AWS)

## Setup
1. Clone this repository.
2. Configure kubectl context to target cluster.
3. Validate manifests render:
   - kubectl kustomize --load-restrictor LoadRestrictionsNone k8s/overlays/staging
   - kubectl kustomize --load-restrictor LoadRestrictionsNone k8s/overlays/production
4. Update ansible/inventory/inventory.ini with target hosts if you are provisioning infrastructure.
5. Configure Jenkins job to use root Jenkinsfile.
6. Run pipeline with RUN_INFRA_PROVISION=false for deploy-only flow.
7. Run pipeline with RUN_INFRA_PROVISION=true only when Terraform and Ansible credentials are configured.

## Pipeline run process
1. Build and Test.
2. Validate Kubernetes Overlays.
3. Optional Provision Staging Infrastructure.
4. Deploy Staging.
5. Staging Smoke Test.
6. Approve Production Deploy.
7. Deploy Production.

## Verification steps
1. Confirm staging rollout:
   - kubectl -n kijani-staging rollout status deployment/kk-payments --timeout=180s
2. Confirm production rollout:
   - kubectl -n kijani-production rollout status deployment/kk-payments --timeout=180s
3. Confirm environment-specific configuration:
   - kubectl -n kijani-staging get configmap kk-payments-config -o yaml
   - kubectl -n kijani-production get configmap kk-payments-config -o yaml
4. Confirm monitoring rule file exists and is loaded by your Prometheus setup:
   - monitoring/alerts.yml

## Known limitations
- Live evidence screenshots are not committed yet and must be captured during real pipeline runs.
- architecture.png is a placeholder until the final architecture diagram is exported.
- Provisioning stage requires environment-specific credentials and inventory values.
- Receipts-chain runtime validation still requires your Week 10 serverless environment.
