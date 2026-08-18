# SonarQube branch runbook

This document applies to `sonarqube-poc`. The scanner runs locally because a
GitHub-hosted runner cannot reach a workstation-only SonarQube server.

## Verified POC environment and result

Run date: **18 August 2026**.

| Item | Verified value |
| --- | --- |
| SonarQube | Community Build 26.8.0.126808 |
| Runtime | Microsoft OpenJDK 21.0.12 |
| Scanner | SonarScanner for .NET 11.2.1 |
| Project key | `github-code-quality-poc` |
| Tests | 6 passed; vulnerable methods were not executed |
| Quality gate | **Failed** (`ERROR`) as intended |
| Bugs / reliability | 8 Bugs; reliability rating E (5.0); 10 reliability impacts |
| Vulnerabilities / security | 10 Vulnerabilities; security rating E (5.0) |
| Code smells / maintainability | 52 Code Smells; 51 maintainability impacts |
| Technical debt | 343 minutes of maintainability remediation effort |
| Coverage | 2.7%; 193 of 199 lines uncovered |
| Duplication | 21.6%; 118 duplicated lines in 2 blocks |
| Complexity | 92 cyclomatic; 51 cognitive |
| Total issues | 70: 5 Blocker, 4 Critical, 25 Major, 34 Minor, and 2 Info |

The failed gate recorded errors for overall reliability, security, coverage,
duplication, and issue count, plus new-code coverage and duplication. Overall
conditions are intentional in this one-project POC so the first comparison scan
can fail; production gates should normally emphasize new code.

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
| Hotspot review | Project **Security Hotspots**; see the version limitation below |
| Coverage and duplication | Project **Measures** |
| Complexity and technical debt | Project **Measures** and issue remediation effort |
| Active rules/profile | **Quality Profiles → C# → Sonar way** (or the assigned custom profile) |
| Gate definition | **Quality Gates → POC - SonarQube vs GitHub** |

## Edition caveat

SonarQube branch and pull-request analysis and some advanced security/reporting
features are edition-dependent. This POC uses a dedicated local project for the
`sonarqube-poc` checkout, so commercial branch analysis is not required for the
core comparison.

## Security Hotspot runtime limitation

The installed 26.8 C# rule catalog reports **zero rules of type
`SECURITY_HOTSPOT`**. SonarSource is transitioning rules that formerly produced
hotspots into vulnerabilities/security issues. Consequently, this verified scan
reported 0 hotspots and no item was available to move through To review,
Acknowledged, Fixed, or Safe. Switching the instance to Standard Experience did
not change the catalog/API classification.

The project gate retains the 100%-reviewed-hotspots condition, but it has no
actual value and therefore does not appear in the evaluated conditions. This is
a real version-specific validation result, not hidden parity. Use a supported
SonarQube version/rule catalog that still emits hotspots if an empirical hotspot
review screenshot is mandatory; otherwise compare GitHub alert triage only as
an operational substitute, not one-to-one parity.