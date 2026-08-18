# Custom CodeQL query pack POC

This branch adds local CodeQL queries to show how organization-specific SonarQube gap rules can be added to GitHub Code Scanning.

## Branch

`custom-codeql-queries-poc`

The branch is based on `github-native-poc`, so the application defect corpus is the same. Only CodeQL configuration and custom query files are added.

## Files added

| File | Purpose |
| --- | --- |
| `.github/codeql/codeql-config.yml` | Runs the built-in `security-and-quality` suite and the local query pack. |
| `.github/codeql/custom-queries/csharp/qlpack.yml` | Defines the local C# query pack. |
| `.github/codeql/custom-queries/csharp/OrgExplicitGCCollect.ql` | Finds explicit `GC.Collect()` calls. |
| `.github/codeql/custom-queries/csharp/OrgEmptyCatchBlock.ql` | Finds empty catch blocks. |
| `.github/codeql/custom-queries/csharp/OrgLockThis.ql` | Finds `lock(this)`. |
| `.github/codeql/custom-queries/csharp/OrgStringConcatInLoop.ql` | Finds string concatenation in loops. |
| `.github/codeql/custom-queries/csharp/OrgLargeMethod.ql` | Finds large methods as a maintainability guardrail. |
| `.github/workflows/codeql.yml` | Uses the new CodeQL config and uploads results as Code Scanning alerts. |

## What this is trying to add beyond `security-extended`

The original GitHub-native workflow used `security-extended`, which focuses on security. This branch uses `security-and-quality` plus local custom queries so CodeQL Code Scanning can also show additional SonarQube-like reliability and maintainability findings.

Expected additional rule families include:

- Explicit garbage collection.
- Empty catch block.
- Locking on `this`.
- String concatenation in a loop.
- Large or complex method.
- Other built-in `security-and-quality` CodeQL quality alerts.

## Where to view results after the workflow completes

1. Open **Actions**.
2. Select **CodeQL security** for branch `custom-codeql-queries-poc`.
3. Confirm the workflow succeeded.
4. Open **Security and quality → Code scanning**.
5. Filter by branch or ref:

```text
ref:refs/heads/custom-codeql-queries-poc is:open
```

Direct link:

<https://github.com/ms-pwc/github-code-quality/security/code-scanning?query=ref%3Arefs%2Fheads%2Fcustom-codeql-queries-poc+is%3Aopen>

## Verified result

Run: <https://github.com/ms-pwc/github-code-quality/actions/runs/32140417137>

Branch: `custom-codeql-queries-poc`

Result: **47 open Code Scanning alerts** uploaded by CodeQL.

This is much broader than the original `security-extended` result because this branch runs:

1. Built-in `security-and-quality` queries.
2. Local organization-specific SonarQube gap queries.

### Custom organization query hits

| Custom rule | Count | Why it matters for SonarQube migration |
| --- | ---: | --- |
| `ms-pwc/csharp/large-method` | 3 | Demonstrates an organization-specific maintainability guardrail for large/complex methods. |
| `ms-pwc/csharp/empty-catch-block` | 1 | Demonstrates reliability/error-handling coverage. |
| `ms-pwc/csharp/explicit-gc-collect` | 1 | Demonstrates a performance/reliability code-smell rule. |
| `ms-pwc/csharp/lock-this` | 1 | Demonstrates a concurrency/reliability rule. |
| `ms-pwc/csharp/string-concat-in-loop` | 1 | Demonstrates a performance/maintainability code-smell rule. |

Custom-query total: **7 alerts**.

### Built-in `security-and-quality` examples also surfaced

| Rule family | Example count |
| --- | ---: |
| Constant condition | 2 |
| Simplifiable Boolean expression | 2 |
| Possible null dereference | 2 |
| Self-assignment | 2 |
| Missing dispose | 1 |
| Invalid string formatting | 1 |
| Off-by-one index | 1 |
| Empty collection | 1 |
| Unused collection | 1 |
| Lock on `this` | 1 |
| Explicit `GC.Collect()` | 1 |
| String concatenation in loop | 1 |

Security findings such as SQL injection, command injection, path traversal, unsafe XML, regex injection, unsafe redirect, cookie security, log forging, and ECB encryption also remain visible in Code Scanning.

## What this proves

Use this wording in the demonstration:

> The original CodeQL security workflow does not try to reproduce every SonarQube quality rule. When we need more SonarQube-like checks, we can extend CodeQL with built-in `security-and-quality` queries and organization-specific query packs. In this branch, the same POC source produced 47 GitHub Code Scanning alerts, including 7 alerts from custom organization rules.

## What this still does not prove

This does **not** mean every SonarQube issue is now reproduced exactly.

Still not exact native parity:

- SonarQube duplication percentage and duplicated-block metrics.
- Aggregate cyclomatic/cognitive complexity totals.
- Technical-debt remediation minutes.
- Exact Security Hotspot reviewed metric and workflow.
- Centralized inherited Quality Profile model.
- Every custom Sonar rule unless it is explicitly rewritten as a CodeQL query or custom check.

## Recommended production pattern

For a real organization migration:

1. Export SonarQube rules and Quality Gate conditions.
2. Map built-in GitHub coverage first: CodeQL, Code Quality, coverage, rulesets.
3. For remaining mandatory rules, create a CodeQL query pack.
4. Test each query with positive and negative fixtures.
5. Publish the query pack to GitHub Container Registry.
6. Reference the pack in CodeQL workflows or a shared CodeQL config.
7. Make CodeQL alerts part of the ruleset merge policy.
8. Keep a mapping table from each SonarQube custom rule to the replacement CodeQL query ID.

## Important explanation for the demo

Use this wording:

> Built-in CodeQL security queries do not reproduce every SonarQube quality rule. For organization-specific rules or important SonarQube gaps, we can add CodeQL query packs. This branch demonstrates that approach by adding local C# queries for reliability and maintainability cases and uploading them to GitHub Code Scanning.

## Limitation

Custom CodeQL queries can add more rules, but they still do not automatically reproduce all 70 SonarQube issues. Some SonarQube metrics such as duplication percentage, aggregate complexity totals, technical debt minutes, and the exact hotspot-reviewed metric remain separate gaps unless implemented with another custom analyzer or accepted as governance differences.