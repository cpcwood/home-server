# Reads the account-scoped GitHub OIDC provider that the cpcwood-k8s platform
# stack creates. Importing it via data avoids the two repos racing to own the
# same `aws_iam_openid_connect_provider` resource.
# Looked up by ARN, not URL: a URL lookup forces iam:ListOpenIDConnectProviders
# (account-wide, no resource scoping), whereas ARN needs only the scoped
# iam:GetOpenIDConnectProvider granted below.
data "aws_iam_openid_connect_provider" "github" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repository}:ref:refs/heads/main",
        "repo:${var.github_repository}:pull_request",
      ]
    }
  }
}

data "aws_iam_policy_document" "github_actions_permissions" {
  # Shared bucket — scope listing to this stack's prefix so CI can't enumerate
  # other stacks' state.
  statement {
    sid       = "TerraformStateList"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::cpcwood-terraform-remote-state"]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["home-server/*"]
    }
  }
  statement {
    sid       = "TerraformStateBucketVersioning"
    effect    = "Allow"
    actions   = ["s3:GetBucketVersioning"]
    resources = ["arn:aws:s3:::cpcwood-terraform-remote-state"]
  }
  statement {
    sid    = "TerraformStateObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["arn:aws:s3:::cpcwood-terraform-remote-state/home-server/*"]
  }

  statement {
    sid    = "ManageOwnS3Buckets"
    effect = "Allow"
    # s3:Get* (not just GetBucket*): aws_s3_bucket refresh reads sub-resource
    # configs — accelerate, replication — whose IAM actions aren't GetBucket*-
    # prefixed. Scoped to this single CI-owned bucket.
    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:Get*",
      "s3:PutBucket*",
      "s3:ListBucket*",
      "s3:PutEncryptionConfiguration",
      "s3:PutLifecycleConfiguration",
    ]
    resources = [
      aws_s3_bucket.application_storage_s3.arn,
    ]
  }

  statement {
    sid    = "ManageOwnParameters"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
      "ssm:ListTagsForResource",
    ]
    resources = ["arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.secret_prefix}/*"]
  }

  # ssm:DescribeParameters has no resource-level support (must be "*"); the
  # aws_ssm_parameter refresh calls it to read parameter metadata. Metadata
  # only — values stay gated by the prefix-scoped GetParameter above.
  statement {
    sid       = "DescribeParameters"
    effect    = "Allow"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    sid       = "DecryptSsmParameters"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ssm.${data.aws_region.current.region}.amazonaws.com"]
    }
  }

  # Scoped to the app's S3 storage user ARN so CI can't touch any other
  # IAM principal.
  statement {
    sid    = "ManageAppStorageUser"
    effect = "Allow"
    actions = [
      "iam:GetUser",
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:TagUser",
      "iam:UntagUser",
      "iam:ListUserTags",
      "iam:GetUserPolicy",
      "iam:PutUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:ListUserPolicies",
      "iam:ListAttachedUserPolicies",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:UpdateAccessKey",
      "iam:ListAccessKeys",
      "iam:GetAccessKeyLastUsed",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/home-server-app-storage-${var.environment}",
    ]
  }

  # SES identity actions don't support resource-level scoping — `*` is required.
  statement {
    sid    = "SesManagement"
    effect = "Allow"
    actions = [
      "ses:VerifyDomainIdentity",
      "ses:VerifyDomainDkim",
      "ses:DeleteIdentity",
      "ses:GetIdentityVerificationAttributes",
      "ses:GetIdentityDkimAttributes",
      "ses:ListIdentities",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SesSmtpUser"
    effect = "Allow"
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:GetUser",
      "iam:TagUser",
      "iam:UntagUser",
      "iam:ListUserTags",
      "iam:PutUserPolicy",
      "iam:GetUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:ListUserPolicies",
      "iam:ListAttachedUserPolicies",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:UpdateAccessKey",
      "iam:ListAccessKeys",
      "iam:GetAccessKeyLastUsed",
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/home-server-${var.environment}-ses-smtp"]
  }

  # Read-only on the OIDC provider so plan can refresh the data source.
  statement {
    sid       = "ReadOIDCProvider"
    effect    = "Allow"
    actions   = ["iam:GetOpenIDConnectProvider"]
    resources = [data.aws_iam_openid_connect_provider.github.arn]
  }

  # Read-only on its own role so apply can refresh.
  statement {
    sid    = "ReadOwnRole"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/home-server-github-actions-${var.environment}"]
  }

  # Deny beats any Allow — CI can never alter the role it runs as or the OIDC
  # provider it trusts. Both are managed at bootstrap with elevated credentials.
  # Operational trap: a PR that edits this role's policy/trust passes `plan` but
  # FAILS `apply` on main (the role can't change itself) — such changes must be
  # applied locally via scripts/bootstrap.sh, not through CI.
  statement {
    sid    = "DenySelfModification"
    effect = "Deny"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:DeleteRolePermissionsBoundary",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:RemoveClientIDFromOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:DeleteOpenIDConnectProvider",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/home-server-github-actions-${var.environment}",
      data.aws_iam_openid_connect_provider.github.arn,
    ]
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "home-server-github-actions-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy" "github_actions" {
  name   = "home-server-github-actions-${var.environment}"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions_permissions.json
}
