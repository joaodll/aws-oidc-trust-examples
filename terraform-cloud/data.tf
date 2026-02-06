data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc_oidc.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "${local.client_id_list}:sub"
      values = [
         "organization:acme-corp:project:some-project:workspace:*:run_phase:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.client_id_list}:aud"
      values   = ["aws.workload.identity"]
    }
  }
}
