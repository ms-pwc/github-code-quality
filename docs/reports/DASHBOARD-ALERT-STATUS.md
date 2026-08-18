# GitHub Security and quality dashboard alert status

Verified on **18 August 2026** against the default branch.

| GitHub view | Open findings | Implemented proof |
| --- | ---: | --- |
| Code Quality → Standard findings | 4 | Three reliability findings and one maintainability finding in `dashboard-fixtures`. |
| Code scanning | 2 | Critical command injection and high path traversal CodeQL alerts on `main`. |
| Secret scanning | 2 | Invalid synthetic Slack and Stripe token-shaped strings; push-protection bypass is audited as `used_in_tests`. |
| Dependabot → Vulnerabilities | 1 | High-severity Newtonsoft.Json advisory from an isolated historical package fixture. |
| Code Quality → AI findings | Non-deterministic | Enabled with `ai_findings_option: on_push`; two semantic logic defects were submitted in a completed managed scan. GitHub exposes no public REST count for this view. |
| Dependabot → Malware | 0 intentionally | **NOT DONE:** adding malware solely to manufacture a dashboard alert is unsafe and is not part of this POC. |

## Live views

- [Standard Code Quality findings](https://github.com/ms-pwc/github-code-quality/security/code-quality)
- [Default-branch CodeQL alerts](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen)
- [Open Secret Scanning alerts](https://github.com/ms-pwc/github-code-quality/security/secret-scanning?query=is%3Aopen)
- [Dependabot vulnerabilities](https://github.com/ms-pwc/github-code-quality/security/dependabot)
- [AI findings](https://github.com/ms-pwc/github-code-quality/security/code-quality/ai-findings)

## Findings created

### Standard Code Quality

1. Dereferenced variable is always null — reliability/error.
2. Self-assignment — reliability/error.
3. Container contents are never accessed — maintainability/error.
4. `Path.Combine` may silently drop earlier arguments — reliability/note.

### Code scanning

1. Uncontrolled command line — critical.
2. Uncontrolled data used in path expression — high.

### Secret scanning

1. Slack API Token — invalid synthetic value, open for demonstration.
2. Stripe API Key — invalid synthetic value, open for demonstration.

### Dependabot

1. Newtonsoft.Json 12.0.1 — high severity, GHSA-5crp-9r3c-p9vr.

## Safety boundary

The fixture project is not deployed, vulnerable methods are never executed, and token-shaped values have never authenticated to any service. Do not replace the synthetic values with real credentials and do not add malicious packages to populate the Malware view.
