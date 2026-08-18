# Security and responsible use

This repository is an isolated static-analysis demonstration. The two POC
branches intentionally contain examples of injection, unsafe file access, weak
cryptography, insecure transport configuration, reliability defects, and code
smells.

## Safety controls

- The sample must not be deployed or exposed as a running service.
- Tests exercise only safe baseline code and never invoke vulnerable endpoints.
- All credential-like values are explicit synthetic placeholders. The
  `dashboard-fixtures` folder contains invalid token-shaped values solely to
  demonstrate Secret Scanning; they have never authenticated to any service.
- Never commit real secrets, tokens, customer data, or production connection
  strings.
- Run local analysis only on a development workstation or isolated CI runner.
- Delete test projects and analysis results when the evaluation is complete.
- Do not add malware or a malicious package merely to populate a dashboard.

## Reporting an accidental real vulnerability or secret

Do not open a public issue containing sensitive information. Contact the
repository administrators privately, revoke any exposed credential immediately,
and remove it from Git history according to organizational incident procedures.