# GitHub-native SonarQube replacement implementation guide

## Purpose

This is the main implementation guide for replacing the normal SonarQube pre-merge developer workflow with GitHub-native controls across **public and private repositories** and across multiple programming languages.

The GitHub-native replacement is a combination:

| SonarQube responsibility | GitHub-native control |
| --- | --- |
| Security and vulnerabilities | CodeQL code scanning |
| Reliability and bugs | GitHub Code Quality reliability findings |
| Maintainability and code smells | GitHub Code Quality maintainability findings |
| Test coverage | Test tool + Cobertura XML + `actions/upload-code-coverage` |
| Quality Gate and merge blocking | Repository/organization rulesets + required checks |
| Security-sensitive review | CodeQL alert triage, dismissal reasons, audit history, and policy |
| Secret detection | Secret Scanning + push protection |
| Dependency vulnerabilities | Dependency graph + Dependabot + dependency review |
| Custom security rules | CodeQL query packs and model packs |
| Repository/organization visibility | Security and quality views and Security Overview |

> [!IMPORTANT]
> CodeQL alone is not a SonarQube replacement. The replacement pattern is **CodeQL + GitHub Code Quality + coverage + rulesets/required checks**.

---

## 1. Public versus private repository prerequisites

Feature availability and billing can change. Confirm the current GitHub contract and organization policy before rollout.

| Area | Public repository | Private/internal repository |
| --- | --- | --- |
| CodeQL code scanning | Available for public repositories | Requires the appropriate GitHub Code Security entitlement for the organization/repository |
| GitHub Code Quality | Requires eligible GitHub Team or Enterprise Cloud entitlement | Requires eligible GitHub Team or Enterprise Cloud entitlement and repository access assignment |
| GitHub Actions | Standard hosted-runner policy applies | Consumes private-repository Actions minutes unless self-hosted runners are used |
| Secret Scanning | Provider-pattern scanning is available for public repositories | Requires the appropriate Secret Protection/Advanced Security entitlement |
| Push protection | Available for supported public repositories | Requires the appropriate Secret Protection/Advanced Security entitlement |
| Dependabot alerts/updates | Available when dependency graph is enabled | Available when dependency graph is enabled; private registries require credentials/configuration |
| Dependency review | Available for supported repository/plan combinations | Verify GitHub Code Security/organization plan requirements |
| Repository rulesets | Available for public repositories | Requires GitHub Pro, Team, or Enterprise according to repository ownership and visibility |
| Security Overview | Repository view available | Organization/enterprise aggregation is plan and role dependent |
| AI findings and Autofix | Entitlement and AI-credit dependent | Entitlement, AI-credit, privacy, and governance approval required |

### Private-repository checks before implementation

- Confirm GitHub Code Security, GitHub Code Quality, and Secret Protection licensing.
- Confirm which repositories are included in organization-level repository access.
- Confirm active-committer billing and expected Actions usage.
- Configure private package registry access without exposing credentials.
- Decide whether GitHub-hosted or hardened self-hosted runners are required.
- Confirm outbound network access to GitHub, package repositories, and build dependencies.
- Confirm data residency, retention, audit-export, and policy requirements.
- Confirm whether organization owners will enforce settings so repository administrators cannot disable them.

---

## 2. Replacement scope and known gaps

| SonarQube capability | GitHub-native position | Production action |
| --- | --- | --- |
| Vulnerabilities | Replaceable for supported CodeQL languages/frameworks | Map all mandatory rules and custom framework models |
| Bugs/reliability | Replaceable for supported GitHub Code Quality rules | Validate mandatory reliability scenarios |
| Code smells/maintainability | Partial to substantial | Compare the active Sonar profile with the current GitHub rule list |
| Coverage | Replaceable | Generate the same scope in Cobertura and enforce a threshold |
| Quality Gate outcome | Replaceable | Compose CodeQL, Code Quality, coverage, CI, and review rules in a ruleset |
| Security Hotspot workflow | Partial | Define an accepted CodeQL triage/dismissal governance process |
| Duplication percentage/gate | No first-class native equivalent currently proven | Add an approved custom analyzer/check or retain SonarQube for this KPI |
| Aggregate cyclomatic/cognitive complexity | No equivalent native metric currently proven | Add an approved custom analyzer/check or retire the KPI by approval |
| Remediation-time technical debt | No one-to-one equivalent | Replace with findings/age/trends or retain SonarQube reporting |
| Central inherited Quality Profiles | Structurally different | Govern CodeQL packs, managed quality rules, and rulesets as separate controls |
| Historical portfolio reporting | Partial | Validate Security Overview, retention, APIs, and audit exports |
| Unsupported languages | Not replaceable by deterministic GitHub checks | Use another approved scanner or retain SonarQube |

Do not retire SonarQube when a mandatory requirement remains unmapped.

---

## 3. Inventory the existing SonarQube implementation

Complete this before changing GitHub settings.

### Export or record

- SonarQube edition and version.
- All repository languages and frameworks.
- Assigned Quality Profiles for every language.
- Every active rule, severity override, inherited rule, and custom rule/plugin.
- Every Quality Gate condition and threshold.
- New-code definition and reference branch.
- Source, test, generated-code, and coverage exclusions.
- Coverage tool, report format, report paths, and test commands.
- Branch and pull-request analysis behavior.
- Duplication and complexity thresholds.
- Security Hotspot review policy and required reviewed percentage.
- Technical-debt, trend, portfolio, and audit reports.
- PR decoration, webhooks, CI checks, and permissions.
- Exception, false-positive, and risk-acceptance process.

### Suggested rule-mapping sheet

| Sonar rule/condition | Language | Category | Mandatory? | GitHub control | GitHub rule/check | Gap/exception owner | Approval |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Example SQL injection rule | Java | Security | Yes | CodeQL | `java/sql-injection` | None | Approved |
| Coverage ≥ 80% | All | Coverage | Yes | Built-in coverage + ruleset/check | Coverage check | None | Approved |
| Duplication ≤ 3% | All | Maintainability | Yes | Custom check | Selected analyzer | Platform Security | Pending |

---

## 4. Select the implementation model

### Recommended default

Use GitHub-managed defaults where possible:

1. CodeQL **default setup** for standard security analysis.
2. GitHub-managed **Code Quality** analysis.
3. Repository CI to produce Cobertura coverage.
4. Rulesets for merge protection.
5. Secret Scanning, Dependabot, and dependency review.

### Use advanced CodeQL setup when

- Manual/custom build commands are required.
- Multiple operating systems or architectures are required.
- Custom query packs or model packs are required.
- Additional query suites must be selected.
- Generated code or monorepo paths require special handling.
- Private dependencies require custom setup.
- A self-hosted runner is required.

Do not run CodeQL default setup and an advanced CodeQL workflow for the same language/branch unless duplicate analysis is intentional and understood.

---

## 5. Enable enterprise and organization controls

### Enterprise level

For Enterprise Cloud environments:

1. Open enterprise **Settings**.
2. Open **Security and code quality** settings.
3. Allow GitHub Code Quality and required GitHub security products.
4. Configure policy for Actions, runners, AI usage, and bypass governance.
5. Confirm organization owners can assign repository access.

### Organization level

1. Open organization **Settings**.
2. Under **Security**, open **Code quality**.
3. Set repository access:
   - Selected pilot repositories, or
   - Repositories matching a property/filter, or
   - All eligible repositories.
4. Start with a small pilot.
5. Enable **Enforce access** only after the pilot is stable.
6. Configure GitHub Code Security and Secret Protection repository access.
7. Configure organization rulesets only after required check names are known.
8. Define teams allowed to administer rules, dismiss alerts, or use bypass.

Recommended private-repository rollout:

- Tag repositories with custom properties such as `code-quality=pilot`.
- Enable selected repositories first.
- Validate usage and billing.
- Expand with a dynamic filter after acceptance.

---

## 6. Enable repository features

### GitHub Code Quality

1. Push the repository code so GitHub can detect languages.
2. Open repository **Settings → Security → Code quality**.
3. Select **Enable code quality**.
4. Select supported languages.
5. Select a standard or labelled runner.
6. Decide whether AI findings are allowed.
7. Save and verify the managed `Code Quality: Push on <default-branch>` run.

Deterministic GitHub Code Quality languages currently include:

- C#
- Go
- Java
- JavaScript
- TypeScript
- Python
- Ruby

AI analysis may cover additional default-branch languages, but AI findings are non-deterministic and must not replace deterministic PR gates.

Repository API example after GitHub has indexed the language:

```bash
gh api --method PATCH repos/ORG/REPO/code-quality/setup --input - <<'JSON'
{
  "state": "configured",
  "languages": ["csharp", "python", "javascript-typescript"],
  "runner_type": "standard",
  "ai_findings_option": "disabled"
}
JSON
```

If the language is not yet present, the API can return `422`. Push the code and wait for language indexing before retrying.

### CodeQL code scanning

For default setup:

1. Open **Settings → Security → Advanced Security**.
2. Under **CodeQL analysis**, select **Set up → Default**.
3. Confirm languages.
4. Select the default or extended query suite according to policy.
5. For supported languages, configure the threat model if required.
6. Save and verify a scan of the default branch.

### Secret Scanning

Under **Settings → Security → Advanced Security**:

- Enable Secret Scanning.
- Enable push protection.
- Enable validity checks when entitled and approved.
- Enable non-provider patterns when entitled.
- Define who can bypass push protection.
- Require a reason and audit every bypass.
- Never add a real credential as a test fixture.

### Dependency controls

- Enable the dependency graph.
- Enable Dependabot alerts.
- Enable Dependabot security updates.
- Add a Dependabot configuration for package ecosystems and Actions.
- Add dependency review as a required pull-request check.
- Configure private registry access through GitHub-supported secure configuration.

---

## 7. CodeQL advanced workflow template

Select only the languages actually present in the repository. Adjust runners and build commands for compiled languages.

```yaml
name: CodeQL security

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: "17 3 * * 1"
  workflow_dispatch:

permissions:
  contents: read

jobs:
  analyze:
    name: CodeQL (${{ matrix.language }})
    runs-on: ubuntu-latest
    timeout-minutes: 60
    permissions:
      security-events: write
      packages: read
      actions: read
      contents: read
    strategy:
      fail-fast: false
      matrix:
        language:
          - csharp
          - java-kotlin
          - javascript-typescript
          - python
          - go
          - ruby
    steps:
      - name: Check out exact commit
        uses: actions/checkout@v6
        with:
          ref: ${{ github.event.pull_request.head.sha || github.sha }}

      - name: Initialize CodeQL
        uses: github/codeql-action/init@v4
        with:
          languages: ${{ matrix.language }}
          queries: security-extended

      - name: Autobuild compiled languages
        uses: github/codeql-action/autobuild@v4

      # Replace autobuild with an explicit build step when required.

      - name: Analyze
        uses: github/codeql-action/analyze@v4
        with:
          category: /language:${{ matrix.language }}
```

### Language and runner notes

| Language | CodeQL security | GitHub Code Quality deterministic | Build note |
| --- | --- | --- | --- |
| C/C++ | Supported | Not currently in the listed deterministic Code Quality languages | Usually manual/autobuild; include all compiled code |
| C# | Supported | Supported | Autobuild or manual `dotnet build` |
| Go | Supported | Supported | Autobuild or explicit `go build` |
| Java/Kotlin | Supported | Java supported; verify Kotlin quality eligibility | Maven/Gradle autobuild or explicit build |
| JavaScript/TypeScript | Supported | Supported | No compiled CodeQL build normally required |
| Python | Supported | Supported | Install dependencies if framework modeling requires them |
| Ruby | Supported | Supported | Install dependencies if required |
| Rust | Supported by CodeQL security | Not currently listed for deterministic Code Quality | Verify current support and build mode |
| Swift | Supported by CodeQL security | Not currently listed for deterministic Code Quality | Use a compatible macOS runner |
| PHP and other unsupported CodeQL languages | Not supported by CodeQL | AI default-branch analysis may exist but is not a deterministic security gate | Retain another approved security scanner |

For manual builds, use `build-mode: manual` in `init` and place the complete build between `init` and `analyze`.

---

## 8. Code coverage implementation for any language

GitHub built-in coverage requires a **Cobertura XML** report.

### Common generators

| Language | Typical tool/command | Output |
| --- | --- | --- |
| C# | Coverlet with `CoverletOutputFormat=cobertura` | `coverage.cobertura.xml` |
| Python | `pytest --cov=. --cov-report=xml:coverage.xml` | Cobertura-compatible XML |
| JavaScript/TypeScript | Istanbul/nyc with Cobertura reporter | `coverage/cobertura-coverage.xml` |
| Java | JaCoCo plus JaCoCo-to-Cobertura conversion/plugin | Cobertura XML |
| Go | `go test -coverprofile` plus `gocover-cobertura` | `coverage.xml` |
| Ruby | SimpleCov plus Cobertura formatter | Cobertura XML |
| C/C++ | `gcovr --cobertura-pretty -o coverage.xml` | `coverage.xml` |
| PHP | PHPUnit Cobertura output | `coverage.xml`; security scanner still required separately |

### Generic upload workflow

```yaml
name: CI and coverage

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  code-quality: write

jobs:
  test:
    name: Build, test, and collect coverage
    runs-on: ubuntu-latest
    steps:
      - name: Check out exact source commit
        uses: actions/checkout@v6
        with:
          ref: ${{ github.event.pull_request.head.sha || github.sha }}

      - name: Set up language and dependencies
        run: echo "Replace with language-specific setup"

      - name: Run tests and generate Cobertura XML
        run: echo "Replace with a command that creates coverage.xml"

      - name: Upload raw report for audit/troubleshooting
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: coverage-${{ github.run_id }}
          path: coverage.xml
          if-no-files-found: error

      - name: Upload coverage to GitHub Code Quality
        if: >-
          success() &&
          (github.event_name != 'pull_request' ||
           github.event.pull_request.head.repo.full_name == github.repository)
        uses: actions/upload-code-coverage@v1
        with:
          file: coverage.xml
          language: YOUR_LANGUAGE
          label: code-coverage/main
```

Required behavior:

- Run on pushes to the default branch to establish the baseline.
- Run on pull requests to compare the PR branch with the baseline.
- Check out the PR head SHA, not the synthetic merge commit, so line mappings are correct.
- Use the same exclusions and source scope previously used in SonarQube.
- Do not upload coverage from untrusted fork PRs with a write token.
- Never use `pull_request_target` to check out and execute untrusted fork code.

---

## 9. Coverage enforcement

### Preferred GitHub-managed rule

After coverage is uploading successfully:

1. Open **Settings → Rules → Rulesets**.
2. Edit the default-branch ruleset.
3. Enable **Restrict code coverage**.
4. Set:
   - Minimum branch coverage percentage.
   - Maximum allowed coverage drop in percentage points.
5. Start in evaluate mode when available.
6. Verify that a deliberately low-coverage PR would be blocked.
7. Activate after calibration.

The managed coverage rule can be public preview depending on the current GitHub release.

### Workflow fallback

When the managed rule is unavailable, add a required workflow check that reads the root Cobertura `line-rate` and fails below the policy threshold.

```yaml
      - name: Enforce 80% line coverage
        run: |
          python - <<'PY'
          import sys
          import xml.etree.ElementTree as ET
          minimum = 80.0
          rate = float(ET.parse("coverage.xml").getroot().attrib["line-rate"]) * 100
          print(f"Line coverage: {rate:.2f}% (required: {minimum:.2f}%)")
          if rate < minimum:
              sys.exit(1)
          PY
```

Require this job's stable check name in the ruleset.

---

## 10. Dependency review workflow

```yaml
name: Dependency review

on:
  pull_request:
    branches: [main]

permissions:
  contents: read

jobs:
  dependency-review:
    name: Review dependency changes
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
        with:
          ref: ${{ github.event.pull_request.head.sha || github.sha }}

      - uses: actions/dependency-review-action@v4
        with:
          fail-on-severity: moderate
          comment-summary-in-pr: always
```

For private registries, configure registry access using the supported Dependabot and Actions secret mechanisms. Do not place credentials in repository files.

---

## 11. Dependabot configuration

```yaml
version: 2
updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly

  # Add one entry for each ecosystem and manifest root.
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly

  - package-ecosystem: pip
    directory: /
    schedule:
      interval: weekly

  - package-ecosystem: maven
    directory: /
    schedule:
      interval: weekly
```

Use only ecosystems present in the repository. For monorepos, add all required manifest directories.

---

## 12. Ruleset configuration: GitHub Quality Gate replacement

Create the ruleset only after all check contexts have run successfully at least once.

### Target

- Default branch, normally `main`.
- Additional release branches when required.
- Exclude experimental branches only through approved policy.

### Recommended rules

1. **Require a pull request before merging**.
2. Require one or more approvals.
3. Require code-owner review for policy/security files.
4. Dismiss stale approvals after new commits.
5. Require approval after the last push.
6. Require all conversations to be resolved.
7. **Require status checks**:
   - Build and tests.
   - Coverage threshold.
   - Dependency review.
   - Other mandatory application checks.
8. **Require code scanning results**:
   - Tool: CodeQL.
   - Security threshold: normally `high_or_higher` or stricter.
   - Non-security alert threshold according to policy.
9. **Require code quality results**:
   - Errors only, or
   - Warnings and higher, or
   - Notes and higher after calibration.
10. **Restrict code coverage**:
    - Minimum percentage.
    - Maximum drop.
11. Block force pushes and deletion.
12. Require linear history or signed commits if organizational policy requires them.

### Enforcement rollout

- First confirm every required check reports on a recent PR.
- Use **Evaluate** mode when the plan supports it.
- Review rule insights and false-positive volume.
- Move to **Active** after acceptance.
- Keep bypass actors minimal.
- Require an auditable exception reason.
- Test failure, missing-check, and service-outage scenarios.

### Example target policy

| Condition | Suggested starting value |
| --- | --- |
| CodeQL security alerts | Block high and critical |
| Code Quality findings | Block errors; later calibrate warnings |
| Coverage minimum | Existing SonarQube threshold, for example 80% |
| Coverage drop | At most 1 percentage point |
| Reviews | At least 1; more for high-risk repositories |
| Conversations | All resolved |
| Dependency review | Fail moderate or higher according to policy |
| Force push/deletion | Blocked |

---

## 13. CODEOWNERS and policy ownership

Example:

```text
/.github/ @ORG/platform-security
/docs/security/ @ORG/platform-security
/src/security-sensitive-area/ @ORG/application-security
```

The referenced user/team must have appropriate repository permission. Protect:

- CodeQL workflows and configuration.
- Coverage and required-check scripts.
- Dependabot configuration.
- Ruleset-as-code exports if used.
- Custom CodeQL packs/models.
- Security exception documentation.

---

## 14. Quality Profile migration

SonarQube has one central per-language Quality Profile object. GitHub uses separate controls.

### Map each Sonar rule

| Sonar rule type | GitHub destination |
| --- | --- |
| Taint/security vulnerability | CodeQL built-in query or custom query pack |
| Framework not modeled | CodeQL model pack/custom model |
| Reliability bug | GitHub Code Quality rule or custom required check |
| Maintainability/code smell | GitHub Code Quality rule or custom required check |
| Coverage | Coverage workflow and ruleset/check |
| Duplication | Custom analyzer/check or accepted gap |
| Complexity | Custom analyzer/check or accepted gap |
| Hotspot | CodeQL alert review policy or accepted partial mapping |
| Custom Sonar plugin rule | Custom CodeQL query/check, another approved analyzer, or retain SonarQube |

### Version and ownership

- Store custom CodeQL packs in a controlled repository/registry.
- Pin or govern pack versions.
- Require CODEOWNERS review.
- Test pack upgrades in a pilot repository.
- Record disabled/noisy rules and exception rationale.
- Re-run the rule mapping when GitHub adds Code Quality rules.

---

## 15. Security Hotspot replacement process

GitHub does not reproduce the exact SonarQube Hotspot state model.

Use this operational substitute:

1. CodeQL detects security-sensitive code as an alert when a matching query exists.
2. A security reviewer inspects data flow and context.
3. Fix the finding or dismiss it using an approved reason.
4. Require a written justification for dismissal.
5. Limit dismissal permissions.
6. Audit dismissals through GitHub APIs/audit logs.
7. Reopen alerts when assumptions change.
8. Report open, fixed, dismissed, and reopened alerts.

If policy specifically requires the SonarQube Reviewed/Safe percentage, this remains a blocking gap unless the organization approves a changed KPI or custom reporting.

---

## 16. Private repository security considerations

### Fork pull requests

- Workflow tokens from forks are normally read-only.
- Never expose private package or deployment secrets to untrusted fork code.
- Guard coverage upload so it only runs for trusted branches/repository-owned PRs.
- Do not use `pull_request_target` to execute a fork's code.
- Require manual approval for first-time contributors when appropriate.

### Self-hosted runners

- Use ephemeral runners for untrusted builds.
- Isolate networks and credentials.
- Do not reuse a compromised workspace.
- Restrict runner groups to approved repositories.
- Patch runner images and build tools.
- Prevent access to production networks.

### Actions supply-chain policy

- Restrict allowed actions to GitHub-owned and approved publishers.
- Consider pinning third-party actions to immutable commit SHAs.
- Enable dependency review for workflow changes.
- Require CODEOWNERS on `.github/workflows`.
- Use minimal `permissions` in every workflow.

### Private package registries

- Configure organization private-registry access for Code Quality/CodeQL where supported.
- Use environment/repository secrets for Actions.
- Use Dependabot registry configuration for update jobs.
- Never echo credentials or include them in coverage/build artifacts.

---

## 17. Baseline debt and rollout strategy

Do not block every existing issue on day one.

Recommended approach:

1. Run default-branch analysis to establish current debt.
2. Focus merge protection on **new pull-request findings**.
3. Start Code Quality at errors only.
4. Review false positives and framework coverage.
5. Raise to warnings when teams are ready.
6. Track default-branch debt separately.
7. Create remediation PRs for existing findings.
8. Expand organization repository access in phases.

For generated code, tests, fixtures, vendored dependencies, and migrations, define explicit exclusions only after review. Avoid broad exclusions that hide production code.

---

## 18. Validation POC

Use a dedicated non-production repository or isolated branch. Do not insert real vulnerabilities or credentials into a production default branch.

### Minimum scenarios

Security:

- SQL injection.
- Command injection.
- Path traversal.
- Unsafe XML.
- XSS/SSRF where the framework is supported.
- Weak crypto or cookie settings.

Reliability:

- Definite null dereference.
- Off-by-one access.
- Invalid format string.
- Self-assignment.
- Resource handling issue.

Maintainability:

- Unused collection/dead code.
- Redundant conditions.
- Nested logic.
- String concatenation in a loop.
- Deliberate duplicated block for gap validation.

Coverage:

- Healthy default-branch baseline.
- PR with a material coverage drop.

Governance:

- High CodeQL alert blocks merge.
- Coverage failure blocks merge.
- Missing required check blocks merge.
- Required review blocks merge.
- Dependency review failure blocks merge.
- Alert dismissal is audited.

### Evidence to retain

- Branch/commit hashes proving identical test source.
- Workflow URLs and check runs.
- CodeQL alert list and severities.
- Code Quality findings and categories.
- Coverage bot comment and raw Cobertura artifact.
- Ruleset export and rule-insight evidence.
- Secret Scanning and Dependabot state.
- Accepted gaps and stakeholder approval.

---

## 19. Production acceptance criteria

SonarQube can be removed for a repository only when all applicable items pass.

### Feature criteria

- [ ] All languages and frameworks are supported or have an approved alternate scanner.
- [ ] Mandatory Sonar security rules are mapped to CodeQL.
- [ ] Mandatory reliability rules are mapped.
- [ ] Mandatory maintainability rules are mapped.
- [ ] Custom Sonar rules/plugins are replaced or formally retired.
- [ ] Coverage reports match the intended source scope.
- [ ] Coverage threshold and drop policy are enforced.
- [ ] CodeQL security threshold is enforced.
- [ ] Code Quality threshold is enforced.
- [ ] Required checks report reliably.
- [ ] Ruleset is active and bypass is controlled.
- [ ] Secret Scanning and dependency controls are enabled.

### Governance criteria

- [ ] Duplication/complexity/debt requirements are replaced or formally accepted as gaps.
- [ ] Hotspot workflow/KPI difference is approved.
- [ ] Dashboard, audit, retention, and reporting needs are met.
- [ ] Licensing and expected usage are approved.
- [ ] Private-repository network/runner/registry requirements are met.
- [ ] Security, engineering, audit, and policy owners sign off.
- [ ] Evidence and rollback plan are retained.

---

## 20. Decommission SonarQube safely

After acceptance:

1. Freeze and export the final SonarQube configuration and issue baseline.
2. Export required audit/history reports.
3. Confirm every GitHub ruleset is active.
4. Confirm all required checks report on a new PR.
5. Confirm default-branch GitHub scans are healthy.
6. Remove Sonar scanner workflow steps and tokens.
7. Revoke Sonar project tokens.
8. Remove Sonar-specific webhooks and PR decoration.
9. Retain Sonar data according to audit/retention policy.
10. Monitor GitHub findings and check reliability during the agreed stabilization window.
11. Keep a rollback procedure until the migration is formally closed.

---

## 21. Operations after migration

### Weekly/monthly

- Review open CodeQL and Code Quality findings.
- Review dismissals and bypasses.
- Review Dependabot and Secret Scanning alerts.
- Verify scheduled scans are running.
- Check Actions minutes and AI-credit consumption.
- Review failed or timed-out required checks.

### Quarterly or release-based

- Compare the current GitHub rule list with required controls.
- Upgrade CodeQL packs/models and action versions.
- Revalidate framework modeling.
- Review ruleset bypass actors.
- Test coverage baselines and exclusions.
- Review unsupported-language exceptions.
- Reconfirm licensing and private-repository access.

---

## 22. Where teams find results

| Result | GitHub location |
| --- | --- |
| Security vulnerabilities | **Security and quality → Code scanning** |
| Reliability and maintainability | **Security and quality → Code Quality → Standard findings** |
| AI findings | **Security and quality → Code Quality → AI findings** |
| PR source annotations | Pull request **Files changed** and checks |
| Coverage comparison | `github-code-quality[bot]` pull-request comment |
| Coverage raw report | Actions artifact |
| Secret alerts | **Security and quality → Secret scanning** |
| Dependency alerts | **Security and quality → Dependabot → Vulnerabilities** |
| Dependency change policy | Pull-request dependency-review check |
| Merge decision | Pull-request merge box and checks |
| Rules and bypass | **Settings → Rules → Rulesets** |
| Workflow logs | **Actions** |
| Organization posture | Organization **Security Overview / Code Quality** views when entitled |

---

## 23. Reference implementation in this repository

- [Concise capability demonstration](docs/SONARQUBE-TO-GITHUB-NATIVE-DEMO.md)
- [Dashboard alert status](docs/reports/DASHBOARD-ALERT-STATUS.md)
- [GitHub-native POC branch](https://github.com/ms-pwc/github-code-quality/tree/github-native-poc)
- [SonarQube POC branch](https://github.com/ms-pwc/github-code-quality/tree/sonarqube-poc)
- [Blocked demonstration PR](https://github.com/ms-pwc/github-code-quality/pull/1)
- [Active ruleset](https://github.com/ms-pwc/github-code-quality/rules/20972666)

Official references:

- [GitHub CodeQL](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning-with-codeql)
- [GitHub Code Quality](https://docs.github.com/en/code-security/concepts/code-quality/code-quality)
- [GitHub built-in coverage](https://docs.github.com/en/code-security/how-tos/maintain-quality-code/set-up-code-coverage)
- [GitHub rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)
- [Dependabot](https://docs.github.com/en/code-security/dependabot)

---

## Final implementation statement

For eligible repositories using supported languages, the normal SonarQube pre-merge workflow can be implemented with GitHub-native controls. The implementation must be treated as a **composed control architecture**, not a scanner swap.

Retirement remains conditional when the organization requires SonarQube-specific duplication, aggregate complexity, remediation-time technical debt, the exact Security Hotspot reviewed metric, centralized Quality Profiles, unsupported-language scanning, or portfolio reporting that GitHub does not reproduce.
