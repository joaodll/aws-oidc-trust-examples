data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "${local.github-user-content}:sub"
      values = [
        "repo:OWNER/REPO:ref:refs/heads/main",
        "repo:OWNER/REPO:ref:refs/heads/release/*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.github-user-content}:aud"
      values   = [local.client_id_list]
    }
  }
}
