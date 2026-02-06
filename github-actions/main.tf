locals {
  client_id_list      = "sts.amazonaws.com"
  github-user-content = "token.actions.githubusercontent.com"
  name                = "github"
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = [local.client_id_list]

  thumbprint_list = [
    "VWtu7jf8hlodvyPKgmGCqAfbRD4dmdQq8p2gIqjO"
  ]
}

resource "aws_iam_role" "github_role" {
  name               = "${local.name}-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  max_session_duration = 3600 ## Must to be in the range (3600 - 43200)

  depends_on = [aws_iam_openid_connect_provider.github]
}

### Custom and restricted policy example
resource "aws_iam_role_policy" "custom_policy" {
  name = "${local.name}-custom-policy"
  role = aws_iam_role.github_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Sid     = "Some custom Policy based on GitHub Actions Usage"
    Statement = [
      {
        Action = [
          "ec2:*",
          "eks:*",
          "ecr:*",
          "ecs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  depends_on = [aws_iam_role.github_role]
}


### Full AWS Access example
resource "aws_iam_role_policy_attachment" "managed_policy_example" {
  role       = aws_iam_role.github_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
