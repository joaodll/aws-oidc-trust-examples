locals {
  client_id_list = "aws.workload.identity"
  name           = "terraform-cloud"
}
resource "aws_iam_openid_connect_provider" "tfc_oidc" {
  url = "https://app.terraform.io"

  client_id_list = [
    local.client_id_list
  ]

  thumbprint_list = [
    "{TERRAFORM_THUMBPRINT}"
  ]
}

resource "aws_iam_role" "terraform_cloud_role" {
  name               = "${local.name}-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  max_session_duration = 1800 ## 30min

  depends_on = [aws_iam_openid_connect_provider.tfc_oidc]
}

### Custom and restricted policy example
resource "aws_iam_role_policy" "custom_policy" {
  name = "${local.name}-custom-policy"
  role = aws_iam_role.terraform_cloud_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Sid     = "Some custom Policy based on Teraform Cloud Usage"
    Statement = [
      {
        Action = [
          "ec2:*",
          "eks:*",
          "ecr:*",
          "vpc:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  depends_on = [aws_iam_role.terraform_cloud_role]
}


### Full AWS Access example
resource "aws_iam_role_policy_attachment" "managed_policy_example" {
  role       = aws_iam_role.terraform_cloud_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}