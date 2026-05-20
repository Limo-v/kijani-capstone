pipeline {
    agent any

    options {
        timeout(time: 45, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
        timestamps()
    }

    triggers {
        githubPush()
    }

    parameters {
        booleanParam(name: 'RUN_INFRA_PROVISION', defaultValue: false, description: 'Run Terraform and Ansible provisioning validation checks before deployment.')
    }

    environment {
        STAGING_NAMESPACE = 'kijani-staging'
        PRODUCTION_NAMESPACE = 'kijani-production'
        STAGING_OVERLAY = 'k8s/overlays/staging'
        PRODUCTION_OVERLAY = 'k8s/overlays/production'
        SMOKE_TEST_TIMEOUT = '180s'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }

    stages {
        stage('Build and Test') {
            steps {
                sh '''
                    set -euo pipefail
                    echo "Build and test placeholder stage for capstone flow"
                    echo "Add real application build or test commands here if needed"
                '''
            }
        }

        stage('Validate Kubernetes Overlays') {
            steps {
                sh '''
                    set -euo pipefail
                    kubectl kustomize --load-restrictor LoadRestrictionsNone "$STAGING_OVERLAY" > /tmp/staging-render.yaml
                    kubectl kustomize --load-restrictor LoadRestrictionsNone "$PRODUCTION_OVERLAY" > /tmp/production-render.yaml
                    echo "Kustomize render succeeded for staging and production overlays"
                '''
            }
        }

        stage('Validate Cluster Access') {
            steps {
                sh '''
                    set -euo pipefail
                    if [[ ! -f "$KUBECONFIG" ]]; then
                      echo "ERROR: Jenkins kubeconfig not found at $KUBECONFIG"
                      echo "Create /var/lib/jenkins/.kube/config with a valid cluster context for Jenkins."
                      exit 1
                    fi

                    SERVER_URL="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null || true)"
                    if [[ -z "$SERVER_URL" ]] || [[ "$SERVER_URL" == "http://localhost:8080" ]] || [[ "$SERVER_URL" == "https://localhost:8080" ]]; then
                      echo "ERROR: kubectl is targeting localhost:8080 or has no valid cluster server."
                      echo "This usually means Jenkins has no real kubeconfig context configured."
                      exit 1
                    fi

                    kubectl config current-context
                    kubectl cluster-info >/dev/null
                    kubectl -n "$STAGING_NAMESPACE" get ns "$STAGING_NAMESPACE" >/dev/null
                    kubectl -n "$PRODUCTION_NAMESPACE" get ns "$PRODUCTION_NAMESPACE" >/dev/null
                    echo "Cluster access validation succeeded"
                '''
            }
        }

        stage('Provision Staging Infrastructure') {
            when {
                expression { return params.RUN_INFRA_PROVISION }
            }
            steps {
                sh '''
                    set -euo pipefail
                    terraform -chdir=terraform init -backend=false -input=false >/dev/null
                    terraform -chdir=terraform validate
                    ansible-playbook -i ansible/inventory/inventory.ini ansible/playbook.yml --syntax-check
                '''
            }
        }

        stage('Deploy Staging') {
            steps {
                sh '''
                    set -euo pipefail
                    kubectl apply -f k8s/namespaces/kijani-staging.yaml
                    kubectl kustomize --load-restrictor LoadRestrictionsNone "$STAGING_OVERLAY" | kubectl apply -f -
                    kubectl -n "$STAGING_NAMESPACE" rollout status deployment/kk-payments --timeout="$SMOKE_TEST_TIMEOUT"
                '''
            }
        }

        stage('Staging Smoke Test') {
            steps {
                sh '''
                    set -euo pipefail
                    POD_NAME="$(kubectl -n "$STAGING_NAMESPACE" get pods -l app=kk-payments -o jsonpath='{.items[0].metadata.name}')"
                    kubectl -n "$STAGING_NAMESPACE" wait --for=condition=ready "pod/$POD_NAME" --timeout="$SMOKE_TEST_TIMEOUT"
                    kubectl -n "$STAGING_NAMESPACE" logs "$POD_NAME" --tail=30 || true
                    echo "Staging smoke test passed"
                '''
            }
        }

        stage('Approve Production Deploy') {
            steps {
                input message: 'Staging smoke test passed. Approve deployment to production?', ok: 'Deploy Production'
            }
        }

        stage('Deploy Production') {
            steps {
                sh '''
                    set -euo pipefail
                    kubectl apply -f k8s/namespaces/kijani-production.yaml
                    kubectl kustomize --load-restrictor LoadRestrictionsNone "$PRODUCTION_OVERLAY" | kubectl apply -f -
                    kubectl -n "$PRODUCTION_NAMESPACE" rollout status deployment/kk-payments --timeout="$SMOKE_TEST_TIMEOUT"
                '''
            }
        }
    }

    post {
        success {
            echo 'Capstone pipeline completed successfully.'
        }
        failure {
            echo "Pipeline failed. Check ${BUILD_URL}console for details."
        }
        always {
            archiveArtifacts artifacts: 'monitoring/**,docs/**,k8s/**,terraform/**,ansible/**', allowEmptyArchive: true
            cleanWs()
        }
    }
}