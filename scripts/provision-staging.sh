#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is required for provisioning" >&2
  exit 1
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook is required for provisioning" >&2
  exit 1
fi

echo "Running terraform validation"
terraform -chdir="$ROOT_DIR/terraform" init -backend=false -input=false >/dev/null
terraform -chdir="$ROOT_DIR/terraform" validate

echo "Running ansible syntax check"
ansible-playbook -i "$ROOT_DIR/ansible/inventory/inventory.ini" "$ROOT_DIR/ansible/playbook.yml" --syntax-check

echo "Provisioning pre-checks succeeded"
