# GitHub Actions → AWS using OIDC (No Access Keys)

This example demonstrates how to authenticate **GitHub Actions workflows to AWS** using **OpenID Connect (OIDC)** and **IAM trust roles**, instead of long-lived AWS access keys and secrets.

The goal is to provide a **secure, auditable, and low-maintenance** authentication model for CI/CD pipelines.

---
## Authentication model used in this example

Terraform creates:

- An AWS IAM OIDC provider for GitHub Actions that:
  - establishes trust between AWS and GitHub Actions
  - limits tokens to the sts.amazonaws.com audience
  - uses TLS thumbprint pinning to prevent MITM attacks

- An IAM role that:

  - can only be assumed by a specific Owner and repository
  - is scoped to a specific branch / workflow
  - issues short-lived credentials

GitHub Actions:

- The `workflow.yaml` file demonstration that assumes the role at runtime and return the STS Caller Identity

---

## How GitHub Actions OIDC works (high level)

1. A GitHub Actions job starts.
2. GitHub issues a **short-lived OIDC JWT** to the job.
3. The workflow exchanges the token with **AWS STS**.
4. AWS validates the token against an **IAM OIDC provider**.
5. AWS returns **temporary credentials** for a specific IAM role.
6. The job uses those credentials to access AWS.

## Related GitHub and AWS documentations

- [OpenId Connect](https://docs.github.com/en/actions/concepts/security/openid-connect)
- [OIDC in Cloud Providers](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-cloud-providers)
- [Understanding the OIDC Token](https://docs.github.com/en/actions/concepts/security/openid-connect#understanding-the-oidc-token)
- [Obtain the thumbprint for an OpenID Connect identity provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html)

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
