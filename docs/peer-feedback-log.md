# Peer Feedback Log

| Issue ID | Issue | Severity | Resolution | Evidence |
|---|---|---|---|---|
| PF-1 | Reviewer ran setup commands from the wrong directory because README did not explicitly require changing into the project folder before kubectl/kustomize commands. | Blocks setup | Updated README setup flow to include explicit `cd kijani-capstone` and context pre-check (`kubectl config current-context`). | Commit: 4eefa51b33fba62cb9a7bfca83db4315b8ef9b2c; GitHub: https://github.com/Limo-v/kijani-capstone/commit/4eefa51b33fba62cb9a7bfca83db4315b8ef9b2c; file evidence: README.md |
| PF-2 | Failure-path guidance was too abstract; reviewer could not reproduce a safe-fail test without exact commands for fault injection and recovery. | Breaks functionality validation | Added explicit invalid image tag injection, rollout failure check, and restore commands to both README and runbook so staging failure behavior can be tested consistently. | Commit: 4eefa51b33fba62cb9a7bfca83db4315b8ef9b2c; GitHub: https://github.com/Limo-v/kijani-capstone/commit/4eefa51b33fba62cb9a7bfca83db4315b8ef9b2c; file evidence: README.md, docs/runbook.md |
| PF-3 | AI governance review criteria were unclear, so reviewer could not judge whether human review steps were specific enough. | Unclear documentation | Added a peer-review credibility checklist to ai-governance-log with concrete checks for field 7 quality, field 8 human validation, and evidence traceability. | Commit: 4eefa51b33fba62cb9a7bfca83db4315b8ef9b2c; GitHub: https://github.com/Limo-v/kijani-capstone/commit/4eefa51b33fba62cb9a7bfca83db4315b8ef9b2c; file evidence: docs/ai-governance-log.md |

Notes:
- Real commit evidence has been added for each resolved item.
- GitHub Issues are currently not created in this repository; add issue URLs later if your assessor requires issue-level traceability.
