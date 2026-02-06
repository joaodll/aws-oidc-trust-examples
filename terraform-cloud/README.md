# Terraform Cloud → AWS using OIDC (IAM Role)

This example shows how to use **Terraform Cloud workload identity (OIDC)** to authenticate to AWS.

Terraform is used to:
- create an AWS IAM OIDC provider for Terraform Cloud
- create an IAM role with a tightly scoped trust policy
- enforce short-lived AWS credentials via STS

---

## What this code creates

This Terraform configuration provisions:

1. **AWS IAM OpenID Connect provider**
   - Trusts `https://app.terraform.io`
   - Uses `aws.workload.identity` as the audience
   - Pins the root CA via a SHA-1 thumbprint

2. **AWS IAM role**
   - Assumable only by Terraform Cloud
   - Restricted by organization, project, workspace, and run phase
   - Issues temporary credentials (max 30 minutes)
   - Custom or Managed AWS Policies

No AWS access keys are created or stored.

---

## Configure your Terraform Cloud workspace (environment variables)

In the workspace where you want TFC to use dynamic credentials, set the following environment variables (workspace variables):

```hcl
TFC_AWS_PROVIDER_AUTH = true

TFC_AWS_RUN_ROLE_ARN = arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/tfc-prod-vpc-apply-role
```

Optionally:
```hcl
TFC_AWS_PLAN_ROLE_ARN = ARN of role to use during plan (if different)

TFC_AWS_APPLY_ROLE_ARN = ARN of role to use during apply (if different)

TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE = custom audience if you changed it from default aws.workload.identity
```

## Structure

- `main.tf`  - Creates the OIDC provider, IAM role and IAM Policies
- `data.tf`  - Defines the IAM trust policy conditions
- `example/` - Directory that contains usage example
- `provider.tf` - Provider configuration
- `versions.tf` - Provider versions configuration

## Related Terraform Cloud and AWS documentations

- [Use dynamic credentials with the AWS provider](https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials/aws-configuration#configure-aws)
- [Authenticate providers with dynamic credentials](https://developer.hashicorp.com/terraform/tutorials/cloud/dynamic-credentials)
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.tfc_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.terraform_cloud_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.managed_policy_example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

No outputs.