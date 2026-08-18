# Evidence index

Evidence captured on **18 August 2026**. API snapshots are sanitized and contain
no authentication tokens.

## GitHub

- Demonstration pull request: <https://github.com/ms-pwc/github-code-quality/pull/1>
- Code-scanning alerts: <https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=pr%3A1+tool%3ACodeQL+is%3Aopen>
- CodeQL result: 11 alerts (2 critical, 4 high, 5 medium); failing security check.
- Code Quality result: 10 inline findings (9 reliability, 1 maintainability).
- Coverage: 3% on `github-native-poc` versus 100% on `main`; explicit 80% CI
	threshold failed.
- Active ruleset: <https://github.com/ms-pwc/github-code-quality/rules/20972666>;
	pull request merge state is blocked.
- Secret scanning and push protection: enabled; 0 open alerts. Non-provider
	patterns and validity checks remained unavailable/disabled.
- Dependency review: passed; 0 open Dependabot alerts.
- Sanitized API evidence:
	<https://github.com/ms-pwc/github-code-quality/tree/github-native-poc/docs/evidence/github>
- GitHub screenshots:
	<https://github.com/ms-pwc/github-code-quality/tree/github-native-poc/docs/evidence/screenshots/github>

## SonarQube

- Local project key: `github-code-quality-poc`
- Dashboard: `http://localhost:9000/dashboard?id=github-code-quality-poc`
- Version: Community Build 26.8.0.126808; Scanner for .NET 11.2.1.
- Quality gate: **failed** as intended.
- Findings: 10 Vulnerabilities, 8 Bugs, 52 Code Smells, 70 total issues.
- Severity: 5 Blocker, 4 Critical, 25 Major, 34 Minor, 2 Info.
- Coverage: 2.7%; 193 of 199 lines uncovered.
- Duplication: 21.6%; 118 duplicated lines; 2 blocks.
- Complexity: 92 cyclomatic; 51 cognitive.
- Technical-debt remediation effort: 343 minutes.
- Security Hotspots: 0. The installed 26.8 C# catalog exposed no
	`SECURITY_HOTSPOT` rules after the product's rule transition; see the
	branch-specific runbook for the limitation.
- Sanitized API evidence:
	<https://github.com/ms-pwc/github-code-quality/tree/sonarqube-poc/docs/evidence/sonarqube>
- Authenticated screenshots:
	<https://github.com/ms-pwc/github-code-quality/tree/sonarqube-poc/docs/evidence/screenshots/sonarqube>

## Evidence map

| Artifact | What it proves |
| --- | --- |
| `measures.json` | SonarQube coverage, duplication, complexity, debt, ratings, and counts. |
| `quality-gate.json` | Evaluated SonarQube gate status and failed conditions. |
| `issues.json` | SonarQube issue-level rule, type, severity, location, and remediation data. |
| `code-scanning-alerts.json` | GitHub CodeQL rules, severities, source locations, and alert links. |
| `pull-request-review-comments.json` | Inline CodeQL and GitHub Code Quality findings. |
| `pull-request-comments.json` | Built-in coverage comparison comment. |
| `ruleset-details.json` | Exact active merge-control rules and administrator bypass. |
| `repository-security.json` | Secret scanning and Dependabot feature state. |

## Screenshots

Screenshots are stored under `docs/evidence/` with a capture date and a short
description. A screenshot is supporting evidence; API snapshots and live links
are preferred for auditable counts.

## Interpretation warning

Different totals are expected because the products use different rules,
taxonomies, data-flow models, severities, and metric calculations. Compare
coverage of planned scenarios and governance outcomes, not raw issue-count
equality.