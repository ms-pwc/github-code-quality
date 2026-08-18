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

## Detailed component-by-component demonstration guide

### Before starting the demonstration

Prepare these browser tabs before the meeting:

1. [Repository home](https://github.com/ms-pwc/github-code-quality).
2. [SonarQube local dashboard](http://localhost:9000/dashboard?id=github-code-quality-poc).
3. [GitHub Code Quality Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality).
4. [Code scanning alerts on `main`](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen).
5. [POC pull request](https://github.com/ms-pwc/github-code-quality/pull/1).
6. [Coverage comment](https://github.com/ms-pwc/github-code-quality/pull/1#issuecomment-5324136729).
7. [Pull-request checks](https://github.com/ms-pwc/github-code-quality/pull/1/checks).
8. [Active ruleset](https://github.com/ms-pwc/github-code-quality/rules/20972666).
9. [Open Secret Scanning alerts](https://github.com/ms-pwc/github-code-quality/security/secret-scanning?query=is%3Aopen).
10. [Dependabot vulnerabilities](https://github.com/ms-pwc/github-code-quality/security/dependabot).

Before presenting, verify:

- The local SonarQube server is running.
- You are signed in to GitHub with permission to view security results.
- Code Quality shows Standard findings.
- Code scanning is filtered to `main` or to PR `#1` as required.
- The POC pull request remains open and blocked.
- The coverage comment still shows 3% versus 100%.
- Secret Scanning shows two open synthetic alerts.
- Dependabot shows one high vulnerability.

Opening statement:

> This demonstration compares SonarQube with the combined GitHub-native control set on intentionally defective POC code. CodeQL covers security, GitHub Code Quality covers reliability and maintainability, coverage upload covers testing, and rulesets plus required checks provide the merge gate. I will show both what is equivalent and what is not available natively.

---

### Component 1 — SonarQube baseline

#### How the SonarQube side was achieved

- The same POC source was scanned from the `sonarqube-poc` branch.
- SonarScanner for .NET imported OpenCover test coverage.
- A strict POC Quality Gate evaluated security, reliability, coverage, duplication, and issue count.
- API exports and screenshots are retained on the [`sonarqube-poc` branch](https://github.com/ms-pwc/github-code-quality/tree/sonarqube-poc/docs/evidence/sonarqube).

#### Demonstration steps

1. Open the [SonarQube dashboard](http://localhost:9000/dashboard?id=github-code-quality-poc).
2. Point to **Quality Gate: Failed**.
3. Point to **10 vulnerabilities**, **8 bugs**, and **52 code smells**.
4. Point to **2.7% coverage** and **21.6% duplication**.
5. Open **Measures** and show complexity and technical debt.

#### What to say

> This is the SonarQube baseline. It combines security, reliability, maintainability, coverage, duplication, complexity, debt, and the gate in one product. The GitHub replacement will reproduce the normal developer and merge-control outcomes using multiple native controls rather than one dashboard.

#### Expected proof

- Quality Gate: `ERROR`.
- 70 total issues.
- Coverage: 2.7%.
- Duplication: 21.6%.
- Cyclomatic complexity: 92.
- Cognitive complexity: 51.
- Technical debt: 343 minutes.

---

### Component 2 — Security and vulnerabilities

#### How it was achieved in GitHub

- CodeQL advanced setup is defined in [`.github/workflows/codeql.yml`](https://github.com/ms-pwc/github-code-quality/blob/main/.github/workflows/codeql.yml).
- C# is analyzed with the `security-extended` query suite.
- The workflow runs on pushes to `main`, pull requests to `main`, a weekly schedule, and manual dispatch.
- The ruleset requires CodeQL results and blocks security alerts at **high or higher**.
- Isolated source fixtures produce command-injection and path-traversal alerts on `main`.
- The comparison PR contains the broader security corpus.

#### Demonstration steps

1. Open [Code scanning alerts on `main`](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fmain+is%3Aopen).
2. Show the **critical uncontrolled command line** alert.
3. Show the **high path traversal** alert.
4. Open one alert and point to the source location and data-flow explanation.
5. Open the [POC branch alerts](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=pr%3A1+tool%3ACodeQL+is%3Aopen).
6. Show the larger result: 11 alerts, including 2 critical and 4 high.
7. Open the PR checks and show the failing `CodeQL` check.

#### What to say

> SonarQube Security and Vulnerabilities map to GitHub CodeQL. CodeQL follows untrusted data to dangerous operations, reports the source line and flow, annotates the pull request, and supplies a pass/fail result to the ruleset. Here the critical and high findings prevent merge.

#### Expected proof

- `main`: 2 open CodeQL alerts.
- Comparison PR: 11 alerts — 2 critical, 4 high, and 5 medium.
- CodeQL check conclusion: failure.
- Pull request: blocked.

#### Important limitation to state

> CodeQL rule names, severity, supported languages, and framework modeling differ from SonarQube. Production retirement still requires mapping every mandatory Sonar security rule and custom plugin.

---

### Component 3 — Reliability and bugs

#### How it was achieved in GitHub

- GitHub Code Quality is enabled for C# at repository level.
- GitHub runs the managed `Code Quality: Push on main` analysis.
- Deterministic CodeQL quality queries categorize incorrect behavior as **Reliability**.
- The default-branch fixture contains definite null dereference and self-assignment cases.
- The comparison PR contains additional off-by-one, invalid formatting, collection, and Boolean-logic defects.

#### Demonstration steps

1. Open [Code Quality → Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality).
2. Filter or identify the **Reliability** findings.
3. Open **Dereferenced variable is always null**.
4. Open **Self-assignment**.
5. Open the [POC pull-request files](https://github.com/ms-pwc/github-code-quality/pull/1/files).
6. Show inline comments from `github-code-quality[bot]`.

#### What to say

> SonarQube Bugs and Reliability map to GitHub Code Quality Reliability findings. GitHub identifies likely runtime failures or incorrect behavior, shows the exact source line, explains the issue, and gives feedback before merge.

#### Expected proof

- Default branch: reliability findings for null dereference, self-assignment, and unsafe path combination.
- POC PR: 9 inline reliability findings.
- Findings are visible both on the default branch and in the PR diff.

#### Important limitation to state

> The GitHub deterministic rule list is not identical to SonarQube's C# profile. Mandatory reliability rules must be validated against the current GitHub Code Quality rule list.

---

### Component 4 — Maintainability and code smells

#### How it was achieved in GitHub

- GitHub Code Quality classifies maintainability anti-patterns separately from reliability.
- The default-branch fixture intentionally creates a collection whose contents are populated but never read.
- Managed analysis reports it as **Container contents are never accessed** with severity **Error**.
- PR comments provide the same developer feedback before merge.

#### Demonstration steps

1. Stay in [Code Quality → Standard findings](https://github.com/ms-pwc/github-code-quality/security/code-quality).
2. Open **Container contents are never accessed**.
3. Point to category **Maintainability** and severity **Error**.
4. Open the source location.
5. Show the corresponding GitHub Code Quality comment in the POC PR.

#### What to say

> SonarQube Maintainability and Code Smells map to GitHub Code Quality Maintainability findings. The finding is visible on the repository dashboard and at the changed line in the pull request, so the developer receives feedback without leaving GitHub.

#### Expected proof

- At least one open maintainability error on `main`.
- A maintainability inline comment on PR `#1`.
- Source-level explanation and remediation guidance.

#### Important limitation to state

> GitHub Code Quality covered fewer maintainability cases than SonarQube in this POC. It does not reproduce every Sonar smell, rating, or remediation estimate, so rule mapping is required.

---

### Component 5 — Security Hotspot review

#### How the GitHub substitute works

- CodeQL reports security-sensitive code as an alert when a matching query exists.
- Authorized reviewers inspect the alert, source, and data flow.
- The reviewer fixes it or dismisses it with a reason.
- Dismissal reason, actor, and history are auditable.
- Rulesets prevent unresolved high/critical alerts from merging.

#### Demonstration steps

1. Open a security-sensitive CodeQL alert, such as ECB encryption or insecure cookie handling, from the [POC alert list](https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=pr%3A1+tool%3ACodeQL+is%3Aopen).
2. Show the source and data-flow information.
3. Show the alert triage/dismiss control, but do not dismiss the evidence alert during the demonstration.
4. Explain that dismissal must use an approved reason and limited permissions.
5. Return to the ruleset and show unresolved high/critical alerts block merge.

#### What to say

> GitHub provides an auditable security-review workflow through CodeQL alert triage. A reviewer can investigate, fix, or dismiss with a recorded reason. This provides the operational review outcome, but it is not the exact SonarQube Security Hotspot product model.

#### Important limitation to state clearly

> GitHub does not provide SonarQube's exact To review, Acknowledged, Fixed, and Safe states or the `security_hotspots_reviewed` percentage. This is partial parity and requires governance approval if that metric is mandatory.

---

### Component 6 — Code coverage

#### How it was achieved in GitHub

- Tests generate a Cobertura XML report in the [CI workflow](https://github.com/ms-pwc/github-code-quality/blob/main/.github/workflows/ci.yml).
- `actions/upload-code-coverage@v1` uploads coverage to GitHub Code Quality.
- Pushes to `main` establish the default-branch baseline.
- Pull-request runs compare branch coverage with the baseline.
- The workflow checks out the PR head SHA so line mappings match the changed code.

#### Demonstration steps

1. Open the [Code Coverage Overview comment](https://github.com/ms-pwc/github-code-quality/pull/1#issuecomment-5324136729).
2. Point to **100% on `main`**.
3. Point to **3% on `github-native-poc`**.
4. Show the per-file table.
5. Open the [pull-request checks](https://github.com/ms-pwc/github-code-quality/pull/1/checks).
6. Show the failed **Build, test, and collect coverage** check.

#### What to say

> Coverage is generated by the test tool in both products. SonarQube imports its supported report; GitHub imports Cobertura. GitHub shows the branch percentage, baseline comparison, and per-file changes directly on the pull request.

#### Expected proof

- Default branch: 100% application baseline.
- POC branch: 3%.
- Coverage drop: 97 percentage points.
- Raw coverage report retained as an Actions artifact.

#### Important limitation to state

> Percentages are comparable only when source paths, generated-code rules, and exclusions are aligned between SonarQube and GitHub.

---

### Component 7 — Coverage Quality Gate

#### How it was achieved in GitHub

- A PowerShell threshold script reads the root Cobertura `line-rate`.
- The CI workflow requires at least **80%** line coverage on pull requests.
- A value below 80% exits non-zero.
- The coverage job has a stable name and is required by the ruleset.

#### Demonstration steps

1. Open the failed coverage check from [PR checks](https://github.com/ms-pwc/github-code-quality/pull/1/checks).
2. Show the log line with actual coverage and the required 80% threshold.
3. Return to the PR overview.
4. Show that merge is unavailable because a required check failed.

#### What to say

> This is the GitHub equivalent of a SonarQube coverage gate. The implementation is a required workflow check: coverage is calculated, compared with policy, and a failed threshold blocks merge.

#### Important limitation to state

> This POC uses a required workflow check. GitHub also has a managed Restrict code coverage ruleset feature where available, but that managed rule was not configured through the public REST schema in this POC.

---

### Component 8 — Overall Quality Gate and merge blocking

#### How it was achieved in GitHub

The [active ruleset](https://github.com/ms-pwc/github-code-quality/rules/20972666) targets the default branch and requires:

- Pull request before merge.
- One approval.
- Code-owner review.
- Approval after the latest push.
- Resolution of review conversations.
- Successful build, test, and coverage check.
- Successful dependency review.
- CodeQL results.
- No high-or-critical CodeQL security alerts.
- No force push or deletion.

#### Demonstration steps

1. Open the [ruleset](https://github.com/ms-pwc/github-code-quality/rules/20972666).
2. Show that enforcement is **Active** and targets the default branch.
3. Expand pull-request requirements.
4. Expand required checks.
5. Show CodeQL merge protection and the high-or-higher threshold.
6. Open the [POC PR](https://github.com/ms-pwc/github-code-quality/pull/1).
7. Point to the failed CodeQL and coverage checks.
8. Point to the blocked merge state.

#### What to say

> SonarQube uses one Quality Gate object. GitHub composes the same merge decision from rulesets, required checks, security severity protection, coverage, dependency review, and review policy. The controls are distributed, but the outcome is the same: this pull request cannot merge.

#### Expected proof

- Ruleset enforcement: Active.
- Pull request merge state: Blocked.
- CodeQL: failure because of deliberate security alerts.
- Coverage check: failure because 3% is below 80%.
- Dependency review: success.

---

### Component 9 — New-code and pull-request analysis

#### How it was achieved in GitHub

- Workflows run for pull requests targeting `main`.
- CodeQL uploads PR-specific security results.
- GitHub Code Quality posts inline comments through `github-code-quality[bot]`.
- Coverage compares the PR head with the default-branch baseline.
- Required checks report directly in the merge box.

#### Demonstration steps

1. Open [PR `#1`](https://github.com/ms-pwc/github-code-quality/pull/1).
2. Open **Files changed**.
3. Show a CodeQL security annotation.
4. Show a `github-code-quality[bot]` reliability annotation.
5. Show the coverage comment.
6. Show the check summary.

#### What to say

> This is the replacement for SonarQube pull-request decoration and new-code analysis. Security, reliability, maintainability, coverage, and policy results are visible before merge in the normal GitHub review experience.

---

### Component 10 — Secret Scanning and push protection

#### How it was achieved in GitHub

- Secret Scanning is enabled in repository security settings.
- Push protection is enabled.
- The demonstration uses invalid synthetic Slack- and Stripe-shaped values only.
- Push protection blocked the push.
- The bypass was explicitly recorded as `used_in_tests`.
- The two synthetic alerts were reopened so the dashboard contains visible demonstration evidence.

#### Demonstration steps

1. Open [Secret Scanning with `is:open`](https://github.com/ms-pwc/github-code-quality/security/secret-scanning?query=is%3Aopen).
2. Show **Slack API Token**.
3. Show **Stripe API Key**.
4. Open one alert and point to the source location.
5. Show that push protection was bypassed with the test reason.
6. Emphasize that the values are invalid and have never authenticated.

#### What to say

> This is an additional GitHub-native control beyond the core SonarQube comparison. Secret Scanning identifies credential patterns, and push protection stops them before they enter the repository. Every bypass is explicit and auditable.

#### Safety statement

> Never use a real credential for a demonstration. The two values in this repository are invalid synthetic patterns created only to prove detection and push protection.

---

### Component 11 — Dependency vulnerabilities and dependency review

#### How it was achieved in GitHub

- Dependency graph is enabled.
- Dependabot alerts and security updates are enabled.
- [`.github/dependabot.yml`](https://github.com/ms-pwc/github-code-quality/blob/main/.github/dependabot.yml) schedules package and Actions updates.
- The isolated fixture references a historical vulnerable Newtonsoft.Json version.
- Dependency review is a required PR check.

#### Demonstration steps

1. Open [Dependabot vulnerabilities](https://github.com/ms-pwc/github-code-quality/security/dependabot).
2. Show the high-severity Newtonsoft.Json alert.
3. Open the alert and point to the advisory and patched version.
4. Open PR checks and show **Review dependency changes**.
5. Explain that new vulnerable dependencies can be rejected before merge.

#### What to say

> GitHub adds supply-chain controls to the replacement pattern. Dependabot reports vulnerabilities already present in dependencies, while dependency review evaluates dependency changes in each pull request and can block risky additions.

#### Intentional exception

> The Malware view remains empty intentionally. Adding a malicious package only to manufacture an alert would be unsafe and is not required to prove a responsible SonarQube replacement.

---

### Component 12 — AI-assisted quality findings

#### How it was achieved in GitHub

- Repository Code Quality setup has `ai_findings_option: on_push`.
- Semantic logic defects were added to an isolated fixture.
- A managed Code Quality push scan completed after the change.

#### Demonstration steps

1. Open [Code Quality → AI findings](https://github.com/ms-pwc/github-code-quality/security/code-quality/ai-findings).
2. If findings are present, open one and show the explanation.
3. If the page is empty, show that AI findings are enabled in Code Quality settings and explain the non-deterministic behavior.
4. Return to Standard findings and emphasize that deterministic rules—not AI—are used for the reliable quality demonstration.

#### What to say

> AI findings are an optional additional quality signal for issues outside the deterministic rule set. They can improve coverage, but they are non-deterministic, can consume AI credits, and must not be the sole merge gate.

---

### Component 13 — Quality Profiles and custom rules

#### How it is achieved in GitHub

- CodeQL security selection uses query suites such as `security-extended`.
- Organization-specific security rules can be packaged as custom CodeQL query packs.
- Unmodeled frameworks can be described with CodeQL model packs.
- GitHub Code Quality uses GitHub-managed deterministic quality queries.
- Rulesets determine enforcement thresholds and required checks.

#### Demonstration steps

1. Open the [CodeQL workflow](https://github.com/ms-pwc/github-code-quality/blob/main/.github/workflows/codeql.yml).
2. Point to `queries: security-extended`.
3. Open Code Quality Standard findings and explain the managed rule set.
4. Open the ruleset and show policy enforcement.

#### What to say

> SonarQube centralizes all active rules in a Quality Profile. GitHub distributes this across CodeQL suites and packs, managed Code Quality rules, and rulesets. The controls are governable, but there is no single inherited profile object with exact Sonar semantics.

---

### Component 14 — Capabilities that are not available natively

#### Demonstration steps

1. Return to SonarQube Measures.
2. Show **21.6% duplication**.
3. Show **cyclomatic 92** and **cognitive 51**.
4. Show **343 minutes technical debt**.
5. Explain that these exact aggregate measures do not appear in GitHub Code Quality.

#### What to say

> These are the explicit gaps. GitHub Code Quality does not currently provide a first-class duplication percentage and gate, equivalent aggregate complexity totals, or SonarQube's remediation-time debt model. If these are mandatory governance KPIs, we must add an approved custom analyzer or retain SonarQube for those requirements.

#### Do not claim

- Do not say GitHub has exact duplication parity.
- Do not say GitHub has the same complexity dashboard.
- Do not say GitHub calculates the same technical-debt minutes.
- Do not say CodeQL alert dismissal is identical to SonarQube Hotspot Reviewed/Safe.
- Do not say every Sonar custom rule is automatically covered.

---

## Recommended 15-minute presentation order

| Time | Component | Main point to prove |
| ---: | --- | --- |
| 1 minute | Introduction and SonarQube baseline | Establish the comparison and identical POC intent |
| 2 minutes | CodeQL security | Security and vulnerabilities are detected and can block merge |
| 2 minutes | Code Quality | Reliability, bugs, maintainability, and smells appear in GitHub |
| 2 minutes | Coverage | 3% versus 100% is visible; 80% gate fails |
| 2 minutes | Ruleset / Quality Gate | The PR is blocked by composed native policy |
| 1 minute | PR/new-code experience | Developers see findings before merge |
| 2 minutes | Secret Scanning and Dependabot | Additional native security controls are present |
| 1 minute | Hotspot review substitute | Auditable triage is possible but not identical |
| 2 minutes | Gaps and final decision | State duplication, complexity, debt, profile, and reporting limits |

Final presentation statement:

> For this supported repository, GitHub-native tools provide the normal pre-merge SonarQube outcomes: security scanning, reliability and maintainability feedback, coverage visibility and enforcement, pull-request annotations, and merge blocking. The replacement is conditional because exact duplication, aggregate complexity, remediation-time debt, the precise Hotspot reviewed metric, and some centralized governance/reporting features are not native equivalents.

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
