# Default-branch dashboard alert fixtures

This folder intentionally populates GitHub's repository-level Security and
quality dashboards for demonstration. It is isolated from the application and
must never be deployed.

Expected results after GitHub finishes scanning `main`:

- **Code Quality:** deterministic reliability and maintainability findings.
- **Code scanning:** command injection and path traversal alerts.
- **Dependabot vulnerabilities:** a known-vulnerable historical
  `Newtonsoft.Json` package version.
- **Secret scanning:** two distinct, invalid GitHub-token-shaped strings.

The token-shaped strings are synthetic random text, have never authenticated,
and are intentionally bypassed with GitHub's `used_in_tests` reason. No real
credential is stored here.

The **Dependabot Malware** view remains empty intentionally. Adding a malware
package merely to manufacture an alert is unsafe and is not part of this POC.
AI findings are non-deterministic and cannot be forced to produce a result.