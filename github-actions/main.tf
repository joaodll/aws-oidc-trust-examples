resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "{GITHUB_THUMBPRINT}"
  ]
}

resource "aws_iam_role" "github_role" {
  name               = "github-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  max_session_duration = 1800 ## 30min

  depends_on = [aws_iam_openid_connect_provider.github]
}
