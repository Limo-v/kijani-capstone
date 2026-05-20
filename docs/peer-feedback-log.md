# Peer Feedback Log

| Issue ID | Issue | Severity | Resolution | Evidence |
|---|---|---|---|---|
| PF-1 | Reviewer ran setup commands from the wrong directory because README did not explicitly require changing into the project folder before kubectl/kustomize commands. | Blocks setup | Updated README setup flow to include explicit `cd kijani-capstone` and context pre-check (`kubectl config current-context`). Logged as simulated GitHub issue #101 and documented as fixed. | Simulated issue: #101; simulated closing commit ref: `docs: clarify setup working directory and context check - Closes #101`; file evidence: README.md |
| PF-2 | Failure-path guidance was too abstract; reviewer could not reproduce a safe-fail test without exact commands for fault injection and recovery. | Breaks functionality validation | Added explicit invalid image tag injection, rollout failure check, and restore commands to both README and runbook so staging failure behavior can be tested consistently. | Simulated issue: #102; simulated closing commit ref: `docs: add concrete staging fault injection and recovery steps - Closes #102`; file evidence: README.md, docs/runbook.md |
| PF-3 | AI governance review criteria were unclear, so reviewer could not judge whether human review steps were specific enough. | Unclear documentation | Added a peer-review credibility checklist to ai-governance-log with concrete checks for field 7 quality, field 8 human validation, and evidence traceability. | Simulated issue: #103; file evidence: docs/ai-governance-log.md |

Notes:
- Entries above are simulated training examples aligned to Session 4 expectations.
- Before final submission, replace simulated issue/commit references with real GitHub links and actual commit hashes.
