# Branching and Commit Policy

## Branch naming
Use type/description format:
- feature/infrastructure-layer
- feature/delivery-pipeline
- feature/runtime-configuration
- feature/ai-governance
- feature/monitoring
- fix/<description>

## Commit message format
Use conventional commits:
- feat: new capability
- fix: defect correction
- infra: Terraform or Ansible changes
- ci: Jenkins or pipeline changes
- docs: documentation updates
- test: test updates

## Required checks before push
Run these commands:
- git grep -i password
- git grep -i secret
- git grep -i api_key

If a match appears outside example files, fix it before pushing.

## Merge model
- Work only on feature branches.
- Open PRs into main.
- Use meaningful PR descriptions summarizing what changed and why.
