# Kijani Capstone

## What this is
Kijani Capstone is a Track A infrastructure-first DevOps project that deploys kk-payments through a staging-first CI/CD flow, validates health in staging, and promotes to production only after explicit approval.

## Architecture
Architecture diagram: docs/architecture.png
Version control policy: docs/version-control.md

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
2. Change into the project root:
   - cd kijani-capstone
3. Configure kubectl context to target cluster.
4. Confirm active context before deployment work:
   - kubectl config current-context
5. Validate manifests render:
   - kubectl kustomize --load-restrictor LoadRestrictionsNone k8s/overlays/staging
   - kubectl kustomize --load-restrictor LoadRestrictionsNone k8s/overlays/production
   - Update secret values in k8s/kk-payments-secrets.yaml before using outside local/demo environments.
6. Update ansible/inventory/inventory.ini with target hosts if you are provisioning infrastructure.
7. Configure Jenkins job to use root Jenkinsfile.
   - For automatic runs on push, enable webhook triggering in Jenkins job configuration (GitHub hook trigger / multibranch webhook indexing).
   - For local Jenkins service installs, configure kubeconfig for the Jenkins user:
     - sudo mkdir -p /var/lib/jenkins/.kube
     - sudo cp ~/.kube/config /var/lib/jenkins/.kube/config
     - sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube
     - sudo chmod 700 /var/lib/jenkins/.kube && sudo chmod 600 /var/lib/jenkins/.kube/config
     - sudo -u jenkins KUBECONFIG=/var/lib/jenkins/.kube/config kubectl config current-context
8. Run pipeline with RUN_INFRA_PROVISION=false for deploy-only flow.
9. Run pipeline with RUN_INFRA_PROVISION=true only when Terraform and Ansible credentials are configured.

## Failure-path dry run (staging only)
Use this to prove the pipeline stops safely before production when staging is unhealthy.

1. Inject a bad image tag in staging:
   - kubectl -n kijani-staging set image deployment/kk-payments kk-payments=ghcr.io/example/kk-payments:does-not-exist
2. Verify rollout fails:
   - kubectl -n kijani-staging rollout status deployment/kk-payments --timeout=120s
3. Restore expected state from overlay:
   - kubectl kustomize --load-restrictor LoadRestrictionsNone k8s/overlays/staging | kubectl apply -f -
4. Confirm healthy rollout:
   - kubectl -n kijani-staging rollout status deployment/kk-payments --timeout=180s

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
