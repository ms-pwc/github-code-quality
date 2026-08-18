# GitHub-native branch runbook

This document applies to `github-native-poc`. GitHub-native replacement is a
combined control plane, not CodeQL alone.

## Components enabled

| Component | Purpose |
| --- | --- |
| CodeQL advanced setup | Security vulnerabilities and pull-request annotations using the `security-extended` query suite. |
| GitHub Code Quality | Managed C# maintainability/reliability analysis, scores, PR comments, and autofix where available. |
| Built-in code coverage | Cobertura upload, branch percentage, default-branch comparison, and per-file delta. |
| Repository ruleset | Merge control for CodeQL, Code Quality severity, coverage, CI checks, and review policy. |
| Secret scanning + push protection | Detect and prevent supported provider and non-provider secret patterns. |
| Dependabot + dependency review | Dependency alerts, updates, and PR change policy. |

## What runs automatically

- `CI and coverage` builds, runs six safe tests, publishes the report artifact,
  and uploads Cobertura to GitHub Code Quality.
- `CodeQL security` performs C# semantic security analysis with extended
  queries and uploads SARIF to code scanning.
- GitHub's managed `Code Quality` workflow analyzes C# maintainability and
  reliability independently of the repository workflow files.
- `Dependency review` evaluates dependency changes on the pull request.

The workflow checks out the pull-request head SHA instead of the synthetic
merge commit so coverage line numbers map to the source diff.

## Where to look in GitHub

| Evidence | Location |
| --- | --- |
| Security alerts | **Security and quality → Code scanning** |
| Maintainability/reliability | **Security and quality → Code quality → Standard findings** |
| Quality scores | Code Quality overview for the default branch |
| Pull-request findings | Inline comments from `github-code-quality[bot]` and **CodeQL - Code Quality / Analyze** |
| Coverage | Pull-request comment from `github-code-quality[bot]`; CI artifact contains raw Cobertura |
| Merge decision | Pull-request merge box and check summary |
| Secret scanning | **Security and quality → Secret scanning** |
| Dependency alerts | **Security and quality → Dependabot** |
| Rules and bypass | **Settings → Rules → Rulesets** |
| Workflow logs | **Actions** |

## Alert review versus SonarQube hotspots

CodeQL alerts can be fixed or dismissed with a reason and the action is
auditable. This is an operational review substitute, but GitHub does not expose
SonarQube's distinct Security Hotspot type, Safe/Acknowledged/Fixed lifecycle,
or `security_hotspots_reviewed` metric. Do not call this one-to-one parity.

## Quality and coverage gates

The POC policy targets:

- block Code Quality findings at **warning or higher**;
- require CodeQL results and block **high or higher** security alerts;
- require the CI check;
- minimum branch coverage of **80%**;
- maximum coverage drop of **1 percentage point**; and
- one approving review plus resolved conversations.

GitHub's **Require code quality results** and **Restrict code coverage** rules
are product-managed rules. The coverage restriction is currently public
preview. Calibrate in evaluate mode before production enforcement; this public
POC activates the normal merge controls only after checks exist so the default
branch cannot be accidentally locked.

## Export evidence

Run `scripts/Export-GitHubEvidence.ps1` after scans complete. It exports setup,
findings, alerts, workflow runs, rulesets, and security settings through the
authenticated GitHub API. No token is written to disk.

## Important differences from SonarQube

- No verified first-class duplication percentage or duplication gate.
- No equivalent aggregate complexity dashboard or gate was verified.
- No one-to-one remediation-effort technical-debt model.
- No central inherited per-language Quality Profile object for all quality and
  security rules.
- Code Quality is a licensed GitHub Team/Enterprise Cloud feature; public CodeQL
  code scanning is available independently.