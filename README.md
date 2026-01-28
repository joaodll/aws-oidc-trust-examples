# aws-oidc-trust-examples

A small collection of **practical examples** showing how to use **OIDC + IAM trust roles** to grant short-lived AWS credentials to CI/CD systems (GitHub Actions, Terraform Cloud, etc.) without storing AWS access keys and secrets.

---

# Why this project

Long-lived AWS access keys (Access Key ID + Secret Access Key) are brittle and risky:

- Can be leaked (in code, containers, logs, or CI caches).
- Require rotation and secure storage.
- Expand blast radius if credentials are over-permissive.
- Complicate automation (who rotated the key, which environments are using it).

**OIDC (OpenID Connect) + IAM trust roles** remove the need for long-lived keys by allowing trusted identity providers (like GitHub Actions, Terraform Cloud or other Clouds) to request short-lived AWS credentials via `sts:AssumeRoleWithWebIdentity`. The provider proves an identity with an ephemeral token and AWS issues temporary credentials scoped to a role.

**Benefits**

- **No long-lived secrets** in your repos or CI secrets manager.
- **Ephemeral credentials** — automatically time-limited, reducing risk.
- **Fine-grained scoping** — restrict by repository, branch, scope or job via token claims (`sub`, `aud`).
- **Easier audits & rotation** — rotate trust relationship or policies, not secrets spread across systems.
- **Better developer DX** — fewer manual secrets to manage, straightforward role-based workflows.

---

# Quick comparison: OIDC vs Access/Secret Keys

| Aspect | OIDC + Trust Role | Access Key + Secret |
|---|---:|---|
| Secret storage | None required in CI | Required (secrets manager / env) |
| Lifetime | Ephemeral (STS) | Long-lived unless rotated |
| Scope | Role policies + token claim conditions | Key permissions only |
| Rotation | Change role/policy or provider config | Must rotate every key and update all consumers |
| Leak impact | Small (short TTL) | High (until rotated) |
| Automation friendliness | Native for modern CI | Possible but manual / error-prone |

---

## Documentations 

- [OIDC federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html)
- [Federating AWS Identities to external services](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_outbound.html)
- [Assuming a role with web identity or OIDC](https://docs.aws.amazon.com/sdkref/latest/guide/access-assume-role-web.html)
- [How to use trust policies with IAM roles](https://aws.amazon.com/blogs/security/how-to-use-trust-policies-with-iam-roles/)