# Planned scenario matrix

The matrix records the intended comparison corpus. Detection is not assumed;
observed results are populated only after each analyzer completes.

| ID | Area | Deliberate scenario | Fixture | SonarQube target | GitHub-native target |
| --- | --- | --- | --- | --- | --- |
| SEC-01 | Vulnerability | SQL query built from request input | `VulnerableController.SqlInjection` | Vulnerability/taint rule | CodeQL SQL injection |
| SEC-02 | Vulnerability | OS command built from request input | `CommandInjection` | Vulnerability/taint rule | CodeQL command injection |
| SEC-03 | Vulnerability | User-controlled file path | `PathTraversal` | Vulnerability/taint rule | CodeQL path injection |
| SEC-04 | Vulnerability | User-controlled outbound URL | `ServerSideRequestForgery` | Vulnerability/taint rule | CodeQL SSRF |
| SEC-05 | Vulnerability | Request value returned as HTML | `ReflectedCrossSiteScripting` | Vulnerability/taint rule | CodeQL reflected XSS |
| SEC-06 | Vulnerability | User-controlled redirect | `UnvalidatedRedirect` | Security rule | CodeQL URL redirect |
| SEC-07 | Vulnerability | XML permits DTD and resolver | `XmlExternalEntity` | Security rule/hotspot | CodeQL XXE |
| SEC-08 | Vulnerability | Request controls regular expression | `RegularExpressionInjection` | Security rule | CodeQL regex injection/DoS |
| SEC-09 | Vulnerability | Untrusted value in structured log | `LogForging` | Security rule | CodeQL log injection |
| SEC-10 | Vulnerability | Untrusted response header | `ResponseSplitting` | Security rule | CodeQL response splitting |
| HOT-01 | Security review | MD5 password hashing | `WeakPasswordHash` | Security Hotspot | CodeQL weak crypto alert where applicable |
| HOT-02 | Security review | Predictable security code | `PredictableSecurityCode` | Security Hotspot | CodeQL insecure randomness |
| HOT-03 | Security review | Certificate validation always succeeds | `TrustEveryCertificate` | Security Hotspot/vulnerability | CodeQL certificate validation bypass |
| HOT-04 | Security review | AES ECB mode | `EncryptWithEcb` | Security Hotspot | CodeQL weak encryption mode |
| HOT-05 | Security review | Cookie security flags disabled | `InsecureCookie` | Security Hotspot | CodeQL insecure cookie |
| REL-01 | Reliability | Definite null dereference | `DereferenceAlwaysNull` | Bug | Code Quality reliability/error |
| REL-02 | Reliability | Possible null dereference | `DereferenceMaybeNull` | Bug | Code Quality reliability/warning |
| REL-03 | Reliability | Off-by-one array access | `OffByOne` | Bug | Code Quality reliability/error |
| REL-04 | Reliability | Comparison with itself | `CompareIdenticalValues` | Bug/code smell | Code Quality reliability/warning |
| REL-05 | Reliability | `ReferenceEquals` on value types | `ReferenceEqualsValueTypes` | Bug | Code Quality reliability/error |
| REL-06 | Reliability | Character passed as StringBuilder capacity | `CharacterAsCapacity` | Bug | Code Quality reliability/error |
| REL-07 | Reliability | Invalid composite format string | `InvalidFormatString` | Bug | Code Quality reliability/error |
| REL-08 | Reliability | Self-assignment | `SelfAssignment` | Bug/code smell | Code Quality reliability/error |
| REL-09 | Reliability | Disposable stream not disposed | `MissingDispose` | Bug/code smell | Code Quality reliability/warning |
| REL-10 | Reliability | Empty collection size compared below zero | `ImpossibleNegativeCount` | Bug | Code Quality reliability/error |
| REL-11 | Reliability | Non-short-circuit operator can dereference null | `DangerousNonShortCircuit` | Bug | Code Quality reliability/error |
| REL-12 | Reliability | Empty catch | `EmptyCatch` | Code smell | Code Quality reliability/note |
| REL-13 | Reliability | Locking on `this` | `LockPublicObject` | Code smell/bug | Code Quality reliability/warning |
| REL-14 | Reliability | Explicit garbage collection | `ForceGarbageCollection` | Code smell | Code Quality reliability/warning |
| MAINT-01 | Maintainability | Constant/redundant Boolean conditions | `ConstantAndRedundantConditions` | Code smells | Code Quality maintainability |
| MAINT-02 | Maintainability | Combinable nested conditions | `NestedConditions` | Code smell | Code Quality maintainability/note |
| MAINT-03 | Maintainability | Useless assignments and calls | `UselessAssignments` | Code smells | Code Quality maintainability/warning |
| MAINT-04 | Maintainability | Collection populated but never read | `UnusedCollection` | Code smell | Code Quality maintainability/error |
| MAINT-05 | Maintainability | Local parameter shadows member intent | `ShadowMember` | Code smell | Code Quality maintainability/note |
| MAINT-06 | Maintainability | String concatenation in loop | `ConcatenateInLoop` | Code smell/performance | Code Quality reliability/note |
| MAINT-07 | Maintainability | High cognitive complexity | `ComplexPrice` | Complexity/code smell | Partial; no aggregate metric parity claimed |
| DUP-01 | Duplication | Repeated order calculation block | `DuplicatedBusinessRules` | Duplication metric | Known first-class metric gap |
| COV-01 | Coverage | Defect corpus intentionally untested | All POC fixtures | Imported OpenCover + gate | Cobertura upload + PR delta/rule |

## Secure controls

`SafeCalculator` and its six passing tests form the safe baseline. They prove
that the repository can build and produce coverage while vulnerable methods are
never executed.