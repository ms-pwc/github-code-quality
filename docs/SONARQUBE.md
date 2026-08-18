# SonarQube branch runbook

This document applies to `sonarqube-poc`. The scanner runs locally because a
GitHub-hosted runner cannot reach a workstation-only SonarQube server.

## Prerequisites

- SonarQube Community Build or SonarQube Server is running and reports `UP` at
  `http://localhost:9000/api/system/status`.
- .NET 9 SDK is installed.
- A SonarQube user token with project and quality-gate administration rights is
  available for one-time provisioning.
- A project-analysis token is available for scans.

Do not store either token in Git. Set them only in the current shell:

```powershell
$env:SONAR_ADMIN_TOKEN = [Net.NetworkCredential]::new(
  "",
  (Read-Host "SonarQube admin token" -AsSecureString)
).Password
```

For normal use, set environment variables through a secure secret manager or
use the non-echoing prompt pattern above. Clear the variables when finished.

## Create the project and quality gate

Run `scripts/Initialize-SonarQube.ps1`. It idempotently:

1. verifies the server is ready;
2. creates project key `github-code-quality-poc` when absent;
3. creates a POC quality gate when absent;
4. attempts conditions for reliability, security, maintainability, coverage,
   duplication, and reviewed hotspots; and
5. assigns the gate to the project.

Metric availability is edition/version dependent. The script warns rather than
hiding an unsupported gate condition.

## Analyze

Run `scripts/Invoke-SonarAnalysis.ps1` after setting `SONAR_TOKEN`. The script
restores the pinned scanner, builds, runs six safe tests, generates OpenCover,
uploads analysis, and waits for the gate by default.

The deliberate corpus should fail a strict gate. A non-zero scanner result due
to a failed gate is demonstration evidence, not a broken build.

## Export evidence

Run `scripts/Export-SonarEvidence.ps1` after analysis. It stores sanitized JSON
for measures, gate status, issues, and hotspots under
`docs/evidence/sonarqube/`. Tokens are used only in the authorization header and
are never written to evidence files.

## Where to look in SonarQube

| Evidence | Location |
| --- | --- |
| Overview and gate | Project **Overview** |
| Security vulnerabilities | Project **Issues**, filter **Software qualities → Security** |
| Reliability bugs | Project **Issues**, filter **Software qualities → Reliability** |
| Maintainability/code smells | Project **Issues**, filter **Software qualities → Maintainability** |
| Hotspot review | Project **Security Hotspots**; review each as acknowledged/fixed/safe according to policy |
| Coverage and duplication | Project **Measures** |
| Complexity and technical debt | Project **Measures** and issue remediation effort |
| Active rules/profile | **Quality Profiles → C# → Sonar way** (or the assigned custom profile) |
| Gate definition | **Quality Gates → POC - SonarQube vs GitHub** |

## Edition caveat

SonarQube branch and pull-request analysis and some advanced security/reporting
features are edition-dependent. This POC uses a dedicated local project for the
`sonarqube-poc` checkout, so commercial branch analysis is not required for the
core comparison.