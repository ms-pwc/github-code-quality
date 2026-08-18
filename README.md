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
| `sonarqube-poc` | The common defect corpus plus local SonarQube analysis tooling. |
| `github-native-poc` | The identical defect corpus plus GitHub-native analysis configuration. |

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

## Start here

1. Read the [demonstration runbook](docs/DEMONSTRATION.md).
2. Use the [capability matrix](docs/CAPABILITY-MATRIX.md) for parity claims and
	explicit gaps.
3. Use the [evidence index](docs/EVIDENCE.md) to locate SonarQube and GitHub
	results.
4. Review [responsible-use guidance](SECURITY.md) before running the sample.

The POC distinguishes **verified evidence**, **documented capability**, and
**known gap**. It does not claim that the products have one-to-one rule or
metric parity.