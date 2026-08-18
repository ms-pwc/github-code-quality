# SonarQube capabilities demonstrated with GitHub-native tools

## Demonstration conclusion

**Yes — for this supported C# repository, the main SonarQube developer workflow is achievable with GitHub-native tools.**

The replacement is a combination, not one product:

- **CodeQL** provides security vulnerability scanning.
- **GitHub Code Quality** provides reliability, bugs, maintainability, and code-smell findings.
- **GitHub built-in coverage** provides coverage visibility.
- **GitHub Actions checks and repository rulesets** provide the Quality Gate and merge blocking.
- **Secret Scanning and Dependabot** provide additional GitHub-native security controls.

Some SonarQube governance metrics do not have an exact GitHub-native equivalent. These are shown explicitly in the last column.

## SonarQube-to-GitHub-native demonstration matrix

| SonarQube capability | GitHub-native equivalent | Is it possible? | Where to see it | Verified demonstration | What is not possible or different |
| --- | --- | --- | --- | --- | --- |
| **Security** | CodeQL code scanning | **YES** | [Code scanning alerts on main](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen) and [POC branch alerts](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=pr%3A1+tool%3ACodeQL+is%3Aopen) | `main` has 2 alerts: critical command injection and high path traversal. The comparison PR has 11 alerts: 2 critical, 4 high, and 5 medium. | CodeQL does not guarantee an equivalent for every Sonar rule, custom plugin, language, or framework. |
| **Vulnerabilities** | CodeQL security alerts | **YES** | [Security and quality → Code scanning](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen) | SQL injection, command injection, path traversal, insecure XML, regex injection, unsafe redirect, log forging, cookie issues, and ECB encryption were demonstrated. | Rule names and severities differ from SonarQube. Mandatory rules must be mapped before production retirement. |
| **Reliability** | GitHub Code Quality reliability findings | **YES** | [Code Quality → Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality) | Default branch contains reliability findings for null dereference, self-assignment, and unsafe `Path.Combine`. The POC PR contains 9 reliability comments. | GitHub Code Quality currently has a smaller deterministic C# rule set than the SonarQube profile used in this POC. |
| **Bugs** | GitHub Code Quality reliability findings | **YES** | [Code Quality → Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality) | Null dereference, off-by-one access, invalid formatting, self-assignment, empty collection, incorrect `StringBuilder`, and unsafe non-short-circuit logic were demonstrated. | The GitHub category is **Reliability**, not a separate SonarQube-style Bug dashboard and rating model. |
| **Maintainability** | GitHub Code Quality maintainability findings | **YES, WITH RULE-MAPPING** | [Code Quality → Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality) | Default branch has a maintainability error: container contents are never accessed. The POC PR also shows maintainability feedback. | SonarQube detected more maintainability rules in this corpus. Exact rule breadth and scoring are not identical. |
| **Code Smells** | GitHub Code Quality maintainability findings | **YES, PARTIALLY** | [Code Quality → Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality) | Source-level maintainability findings and PR comments are demonstrated. | GitHub does not reproduce every SonarQube smell, remediation estimate, or maintainability rating calculation. |
| **Security Hotspots review** | CodeQL alert review, fix, dismiss-with-reason, and audit history | **PARTIAL** | [Code scanning alerts](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen) | Reviewers can inspect data flow, fix alerts, or dismiss them with an auditable reason. Security-sensitive ECB and cookie cases were detected. | GitHub has no exact SonarQube **To review / Acknowledged / Fixed / Safe** lifecycle and no `security_hotspots_reviewed` percentage. |
| **Code coverage** | GitHub built-in coverage with Cobertura upload | **YES** | [POC pull request coverage comment](https://github.com/ms-pwc/github-code-quality/pull/1#issuecomment-5324136729) | GitHub reports 3% on the POC branch versus a 100% default-branch baseline, including per-file coverage. | Results are comparable only when source scope and exclusions match. |
| **Coverage Quality Gate** | Required GitHub Actions coverage check | **YES** | [Pull request checks](https://github.com/ms-pwc/github-code-quality/pull/1/checks) | The required 80% coverage check fails intentionally and blocks the PR. | The POC uses a required workflow check rather than SonarQube's single central gate condition object. |
| **Quality Gate** | Ruleset + required checks + CodeQL merge protection | **YES — SAME MERGE OUTCOME** | [Active repository ruleset](https://github.com/ms-pwc/github-code-quality/rules/20972666) and [blocked POC PR](https://github.com/ms-pwc/github-code-quality/pull/1) | Security, coverage, CI, dependency review, approval, code-owner review, and conversation-resolution controls are enforced. The PR is blocked. | GitHub distributes the gate across several controls instead of one SonarQube Quality Gate page. |
| **New-code / pull-request analysis** | CodeQL checks, Code Quality PR comments, and coverage comparison | **YES** | [POC pull request](https://github.com/ms-pwc/github-code-quality/pull/1) | Findings appear before merge at the changed source lines. | Calculation baselines and annotation behavior differ from SonarQube editions. |
| **Duplication percentage** | Custom third-party analyzer or custom required check | **NOT AVAILABLE NATIVELY** | SonarQube comparison evidence is on the [`sonarqube-poc` branch](https://github.com/ms-pwc/github-code-quality/tree/sonarqube-poc/docs/evidence/sonarqube) | SonarQube measured 21.6%, 118 duplicated lines, and 2 blocks. | GitHub Code Quality does not currently provide a first-class duplication percentage, duplicated-block dashboard, or native duplication gate. |
| **Cyclomatic and cognitive complexity totals** | Individual Code Quality maintainability rules or an additional custom analyzer | **NOT AVAILABLE AS AN EQUIVALENT NATIVE METRIC** | [SonarQube Measures evidence](https://github.com/ms-pwc/github-code-quality/blob/sonarqube-poc/docs/evidence/sonarqube/measures.json) | SonarQube measured cyclomatic complexity 92 and cognitive complexity 51. | GitHub Code Quality does not expose equivalent aggregate complexity totals or a native complexity gate. |
| **Technical debt / remediation minutes** | Findings, age, trends, or custom reporting | **NOT EQUIVALENT** | [SonarQube Measures evidence](https://github.com/ms-pwc/github-code-quality/blob/sonarqube-poc/docs/evidence/sonarqube/measures.json) | SonarQube calculated 343 minutes of remediation effort. | GitHub has no one-to-one remediation-time technical-debt model. |
| **Quality Profiles** | CodeQL query suites/packs + managed Code Quality rules + rulesets | **PARTIAL** | [CodeQL workflow](https://github.com/ms-pwc/github-code-quality/blob/main/.github/workflows/codeql.yml) | `security-extended` CodeQL queries and GitHub-managed C# Code Quality rules are active. | There is no single centralized inherited per-language profile spanning all GitHub controls. Custom Sonar rules require custom CodeQL/check implementation. |
| **Issue severity** | CodeQL security severity and Code Quality error/warning/note | **YES** | [Code scanning](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen) and [Code Quality](https://github.com/ms-pwc/github-code-quality/security/code-quality) | Critical/high/medium security alerts and error/note quality findings are visible. | SonarQube and GitHub severity taxonomies are different and require governance mapping. |
| **Historical and portfolio reporting** | Repository and organization Security and quality views | **PARTIAL** | Repository-level evidence is available in this POC. | Current repository findings, checks, alert states, and Actions history are demonstrated. | Equivalent SonarQube portfolio history, trend depth, retention, and audit exports were not validated. |
| **Secret detection** | GitHub Secret Scanning and push protection | **YES — ADDITIONAL GITHUB CONTROL** | [Open Secret Scanning alerts](https://github.com/ms-pwc/github-code-quality/security/secret-scanning?query=is%3Aopen) | Two invalid synthetic alerts are open: Slack API Token and Stripe API Key. Push-protection bypass is audited as `used_in_tests`. | This is an additional GitHub-native control, not a direct SonarQube metric. Non-provider patterns and validity checks are not enabled. |
| **Dependency vulnerabilities** | Dependabot alerts and dependency review | **YES — ADDITIONAL GITHUB CONTROL** | [Dependabot vulnerabilities](https://github.com/ms-pwc/github-code-quality/security/dependabot) | One high-severity Newtonsoft.Json alert is open; dependency review and dependency graph are enabled. | The Malware view is intentionally empty because adding malware solely for a demo is unsafe. |
| **AI-assisted quality findings** | GitHub Code Quality AI findings | **POSSIBLE, NON-DETERMINISTIC** | [Code Quality → AI findings](https://github.com/ms-pwc/github-code-quality/security/code-quality/ai-findings) | `ai_findings_option: on_push` is enabled and semantic logic defects were submitted in a completed managed scan. | AI output cannot be forced, is not deterministic, can consume AI credits, and is not a replacement for deterministic gates. |

## Simple demonstration flow

### 1. Show the SonarQube result

Open the local SonarQube project:

- <http://localhost:9000/dashboard?id=github-code-quality-poc>

Show these SonarQube results:

| SonarQube area | POC result |
| --- | ---: |
| Quality Gate | Failed |
| Vulnerabilities | 10 |
| Bugs | 8 |
| Code Smells | 52 |
| Total issues | 70 |
| Coverage | 2.7% |
| Duplication | 21.6% |
| Cyclomatic complexity | 92 |
| Cognitive complexity | 51 |
| Technical debt | 343 minutes |
| Security Hotspots | 0 from the installed 26.8 C# catalog |

### 2. Show security in GitHub

Open:

- [Default-branch CodeQL alerts](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen)
- [Full comparison PR alerts](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=pr%3A1+tool%3ACodeQL+is%3Aopen)

Say:

> SonarQube vulnerabilities are handled by CodeQL. GitHub shows critical and high security findings directly at the source line and blocks the pull request through the ruleset.

### 3. Show reliability, bugs, maintainability, and code smells

Open:

- [GitHub Code Quality Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality)
- [POC pull request files](https://github.com/ms-pwc/github-code-quality/pull/1/files)

Say:

> SonarQube Bugs map to GitHub Code Quality Reliability findings. SonarQube Code Smells and Maintainability map to GitHub Code Quality Maintainability findings. Findings are shown on the default branch and inline before merge.

### 4. Show coverage

Open:

- [Coverage comparison comment](https://github.com/ms-pwc/github-code-quality/pull/1#issuecomment-5324136729)
- [Pull request checks](https://github.com/ms-pwc/github-code-quality/pull/1/checks)

Say:

> The test tool still produces coverage. GitHub ingests the Cobertura report, shows 3% versus the 100% baseline, and the required 80% check blocks the pull request.

### 5. Show the GitHub Quality Gate replacement

Open:

- [Active ruleset](https://github.com/ms-pwc/github-code-quality/rules/20972666)
- [Blocked pull request](https://github.com/ms-pwc/github-code-quality/pull/1)

Say:

> SonarQube uses one Quality Gate object. GitHub achieves the same merge decision through required checks, CodeQL severity protection, coverage, review rules, and the repository ruleset. The pull request is blocked.

### 6. Show additional GitHub-native controls

Open:

- [Secret Scanning](https://github.com/ms-pwc/github-code-quality/security/secret-scanning?query=is%3Aopen)
- [Dependabot](https://github.com/ms-pwc/github-code-quality/security/dependabot)
- [AI findings](https://github.com/ms-pwc/github-code-quality/security/code-quality/ai-findings)

Say:

> GitHub also provides Secret Scanning, push protection, dependency vulnerability alerts, dependency review, and optional AI findings in the same Security and quality experience.

### 7. Finish with the honest gaps

Say:

> For this supported repository, security, reliability, maintainability, code smells, bugs, coverage, PR analysis, and merge enforcement are achievable with GitHub-native tools. Exact SonarQube parity is not available for duplication percentage, aggregate complexity, remediation-time technical debt, the precise Security Hotspot reviewed metric, a single centralized Quality Profile, and some portfolio reporting.

## One-slide summary

| SonarQube area | GitHub-native answer |
| --- | --- |
| Security and vulnerabilities | **YES — CodeQL** |
| Reliability and bugs | **YES — GitHub Code Quality** |
| Maintainability and code smells | **YES for supported GitHub Code Quality rules; rule breadth differs** |
| Coverage | **YES — built-in coverage upload** |
| Quality Gate / merge blocking | **YES — required checks + ruleset** |
| Security Hotspot review | **PARTIAL — auditable CodeQL triage, not the same lifecycle/metric** |
| Duplication percentage | **NO native equivalent** |
| Aggregate complexity | **NO native equivalent** |
| Technical-debt remediation minutes | **NO native equivalent** |
| Centralized Quality Profile | **PARTIAL — distributed GitHub controls** |

## Final statement

**SonarQube can be removed for this repository's normal pre-merge developer workflow if the organization accepts the explicitly listed gaps.**

Do not make this a blanket enterprise decision until every required language, framework, SonarQube rule, Quality Gate condition, report, and policy requirement has been mapped.
