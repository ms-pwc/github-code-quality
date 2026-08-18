# SonarQube vs GitHub-Native Code Quality POC

This public repository is a controlled proof of concept comparing SonarQube with
GitHub CodeQL, GitHub Code Quality, built-in coverage, secret scanning, and
repository rulesets on the **same C# defect corpus**.

> [!CAUTION]
> The POC branches contain deliberately insecure and defective code. The
> application is non-deployable by design. Never reuse the examples in a real
> service and never add real credentials or personal data.

## Branches

| Branch | Purpose |
| --- | --- |
| `main` | Safe baseline, tests, coverage baseline, and shared documentation. |
| [`sonarqube-poc`](https://github.com/ms-pwc/github-code-quality/tree/sonarqube-poc) | The common defect corpus, local SonarQube automation, API evidence, and screenshots. |
| [`github-native-poc`](https://github.com/ms-pwc/github-code-quality/tree/github-native-poc) | The identical defect corpus, CodeQL/Code Quality workflows, API evidence, and screenshots. |

The defect-corpus hashes are recorded in
[docs/DEMONSTRATION.md](docs/DEMONSTRATION.md) so the comparison can be audited.

## What is compared

- Security vulnerabilities
- Security-sensitive code and review workflow
- Reliability defects (bugs)
- Maintainability findings (code smells)
- Test coverage
- Duplicated code and complexity
- Quality gates and merge controls
- Quality profiles and rule configuration
- Technical debt, trends, and reporting
- Secret and dependency scanning as GitHub-native complementary controls

## Verified result at a glance

Evaluation date: **18 August 2026**.

| Evidence | SonarQube Community Build 26.8 | GitHub-native stack |
| --- | --- | --- |
| Security | 10 Vulnerabilities; security rating E | 11 CodeQL alerts: 2 critical, 4 high, 5 medium |
| Reliability | 8 Bugs; reliability rating E | 9 reliability comments from GitHub Code Quality |
| Maintainability | 52 Code Smells; 343 minutes debt | 1 maintainability comment from GitHub Code Quality |
| Coverage | 2.7%; 193/199 lines uncovered | 3% POC branch versus 100% safe baseline; 80% workflow gate failed |
| Duplication | 21.6%; 118 lines; 2 blocks | No verified first-class percentage or gate |
| Complexity | 92 cyclomatic; 51 cognitive | No equivalent aggregate metric verified |
| Enforcement | Quality Gate failed | Pull request and active ruleset blocked merge |
| Hotspot review | 0 emitted by the installed 26.8 C# catalog; see limitation | Alert triage is only an operational substitute |

The intentionally blocked GitHub demonstration is
[pull request 1](https://github.com/ms-pwc/github-code-quality/pull/1). The
local SonarQube dashboard is available at
<http://localhost:9000/dashboard?id=github-code-quality-poc> while the local
server is running.

## Start here

1. Read the [demonstration runbook](docs/DEMONSTRATION.md).
2. Use the [capability matrix](docs/CAPABILITY-MATRIX.md) for parity claims and
	explicit gaps.
3. Use the [evidence index](docs/EVIDENCE.md) to locate SonarQube and GitHub
	results.
4. Review the detailed
   [scenario matrix](https://github.com/ms-pwc/github-code-quality/blob/github-native-poc/docs/SCENARIO-MATRIX.md).
5. Review [responsible-use guidance](SECURITY.md) before running the sample.
6. Follow the branch-specific
	[SonarQube runbook](https://github.com/ms-pwc/github-code-quality/blob/sonarqube-poc/docs/SONARQUBE.md)
	or
	[GitHub-native runbook](https://github.com/ms-pwc/github-code-quality/blob/github-native-poc/docs/GITHUB-NATIVE.md).

The POC distinguishes **verified evidence**, **documented capability**, and
**known gap**. It does not claim that the products have one-to-one rule or
metric parity.