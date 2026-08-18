# Capability matrix

| SonarQube capability | GitHub-native implementation | Verified in this POC | Replacement position |
| --- | --- | --- | --- |
| Vulnerabilities | CodeQL code scanning | SonarQube: 10 Vulnerabilities. CodeQL: 11 alerts (2 critical, 4 high, 5 medium). | Replaceable for mapped supported languages/frameworks; not rule-for-rule parity. |
| Security Hotspots | CodeQL alert triage/dismissal plus review policy | SonarQube 26.8 C# catalog emitted 0 hotspots after rules were transitioned to vulnerabilities; GitHub alerts support auditable dismissal. | Partial only. GitHub has no distinct To review/Acknowledged/Fixed/Safe lifecycle or reviewed-hotspot metric. |
| Bugs / reliability | GitHub Code Quality reliability findings | SonarQube: 8 Bugs and 10 reliability impacts. GitHub: 9 inline reliability findings. | Replaceable for mapped rules; taxonomies and severities differ. |
| Code smells / maintainability | GitHub Code Quality maintainability findings | SonarQube: 52 Code Smells. GitHub: 1 inline maintainability finding from the deterministic C# rule set. | Partial. SonarQube showed materially broader rule coverage in this corpus. |
| Coverage | Test runner + Cobertura + `actions/upload-code-coverage` + threshold check | GitHub: 3% branch versus 100% baseline and failed 80% CI gate. SonarQube: 2.7% and failed 80% gate. | Replaceable when report scope and exclusions are aligned. |
| Quality Gate | Code-scanning merge protection, required checks, coverage check, and rulesets | SonarQube gate failed. GitHub pull request was blocked by a failed security check, failed coverage check, and active ruleset. | Equivalent merge outcome; GitHub administration is distributed. |
| Duplication | No verified first-class GitHub Code Quality percentage/gate | SonarQube: 21.6%, 118 duplicated lines, 2 blocks. No GitHub-native duplication metric observed. | Gap. Add a separate analyzer/custom check if mandatory. |
| Complexity | Individual quality rules | SonarQube: cyclomatic 92 and cognitive 51. No equivalent aggregate GitHub metric observed. | Partial/gap. |
| Technical debt | Findings, age, scores, APIs, and custom reporting | SonarQube: 343 minutes remediation effort. No equivalent GitHub remediation-time total observed. | Real gap for SonarQube's debt model. |
| Quality profiles | CodeQL suites/packs, managed Code Quality rules, and rulesets | SonarQube used C# `Sonar way`; CodeQL used `security-extended`; Code Quality used GitHub's managed C# list. | Partial; no single GitHub inherited per-language profile object spanning all controls. |
| History and portfolios | Repository/organization security and quality views | Repository evidence verified; portfolio-depth and retention were not tested. | Partial; validate audit and management-reporting requirements. |
| Secret detection | GitHub secret scanning and push protection | Enabled; 0 open alerts. Non-provider patterns and validity checks were unavailable/disabled in this repository. | Complementary GitHub control, not a SonarQube metric. |
| Dependency risk | Dependabot and dependency review | Dependency review passed; 0 open Dependabot alerts. | Complementary GitHub control, not a direct SonarQube metric. |

## Claim boundary

The correct replacement comparison is **SonarQube versus CodeQL + GitHub Code
Quality + coverage upload + rulesets/required checks**. CodeQL by itself is a
security scanner and is not a full code-quality platform.

Exact parity is not claimed for custom Sonar rules, unsupported languages,
duplication percentage, cognitive/cyclomatic complexity totals, technical-debt
remediation estimates, the hotspot-reviewed metric, or historical portfolio
reporting.

## Demonstrated GitHub policy composition

The active ruleset requires a pull request, approval, code-owner review,
resolved conversations, successful CI, dependency review, CodeQL results, and
no high-or-critical security alerts. An explicit CI check enforces 80% line
coverage. GitHub's product-managed **Require code quality results** and
**Restrict code coverage** rules are documented capabilities, but their public
REST rule schema was not available in this run, so they were not claimed as
API-verified rules.

## Product and edition boundaries

- GitHub Code Quality requires eligible GitHub Team or Enterprise Cloud
	entitlement and consumes Actions/AI usage according to current billing.
- Public CodeQL code scanning, secret scanning, Dependabot, and public-repository
	rulesets have different plan requirements from Code Quality.
- SonarQube features vary by Community Build/Server edition and version.
- Branch/PR analysis, advanced reporting, languages, custom plugins, and
	security rules must be checked against the intended SonarQube edition.
- Pricing, contracts, and organization policy were not evaluated.