# Capability matrix

| SonarQube capability | GitHub-native implementation | Position |
| --- | --- | --- |
| Vulnerabilities | CodeQL code scanning | Replaceable for supported languages/frameworks after rule validation. |
| Security Hotspots | CodeQL alert triage/dismissal plus review policy | Partial: operational substitute, not SonarQube's distinct hotspot model or reviewed-hotspot metric. |
| Bugs / reliability | GitHub Code Quality reliability findings | Replaceable for mapped rules; taxonomies and severities differ. |
| Code smells / maintainability | GitHub Code Quality maintainability findings | Partial to substantial; rule breadth differs. |
| Coverage | Test runner + Cobertura + `actions/upload-code-coverage` | Replaceable; both products ingest a test-tool report rather than running tests themselves. |
| Quality Gate | Code Quality rules, code-scanning merge protection, required checks, and rulesets | Equivalent merge outcome; distributed administration rather than one gate object. |
| Duplication | No verified first-class GitHub Code Quality duplication percentage/gate | Gap; use an additional analyzer/custom check if this metric is mandatory. |
| Complexity | Individual maintainability rules; no verified aggregate Sonar complexity metric | Partial/gap. |
| Technical debt | Findings, age, scores, APIs, and custom reporting | Gap for SonarQube's remediation-effort/debt model. |
| Quality profiles | CodeQL suites/packs, Code Quality managed rules, and rulesets | Partial; no single inherited per-language profile object. |
| History and portfolios | Repository/organization security and quality views | Partial; reporting depth and retention must be validated. |
| Secret detection | GitHub secret scanning and push protection | GitHub-native complementary control, not a direct SonarQube metric. |
| Dependency risk | Dependabot and dependency review | GitHub-native complementary control, not a direct SonarQube metric. |

## Claim boundary

The correct replacement comparison is **SonarQube versus CodeQL + GitHub Code
Quality + coverage upload + rulesets/required checks**. CodeQL by itself is a
security scanner and is not a full code-quality platform.

Exact parity is not claimed for custom Sonar rules, unsupported languages,
duplication percentage, cognitive/cyclomatic complexity totals, technical-debt
remediation estimates, the hotspot-reviewed metric, or historical portfolio
reporting.