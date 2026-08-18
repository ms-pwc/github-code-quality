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

## Important explanation for the demo

Use this wording:

> Built-in CodeQL security queries do not reproduce every SonarQube quality rule. For organization-specific rules or important SonarQube gaps, we can add CodeQL query packs. This branch demonstrates that approach by adding local C# queries for reliability and maintainability cases and uploading them to GitHub Code Scanning.

## Limitation

Custom CodeQL queries can add more rules, but they still do not automatically reproduce all 70 SonarQube issues. Some SonarQube metrics such as duplication percentage, aggregate complexity totals, technical debt minutes, and the exact hotspot-reviewed metric remain separate gaps unless implemented with another custom analyzer or accepted as governance differences.