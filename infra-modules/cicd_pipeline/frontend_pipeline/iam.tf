# IAM role and policy for CodePipeline
resource aws_iam_role codepipeline_frontend {
  name                 = "${var.application_name}-codepipeline-${var.environment}"
  assume_role_policy   = data.aws_iam_policy_document.codepipeline.json
}

data "aws_iam_policy_document" "codepipeline" {
   statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  } 
}

resource aws_iam_policy codepipeline_frontend {
  name        = "${var.application_name}-codepipeline-${var.environment}"
  description = "Allow Codepipeline deployments"
  policy      = data.aws_iam_policy_document.codepipeline_frontend.json
}

resource aws_iam_role_policy_attachment codepipeline_frontend {
  role       = aws_iam_role.codepipeline_frontend.name
  policy_arn = aws_iam_policy.codepipeline_frontend.arn
}

data aws_iam_policy_document codepipeline_frontend {
  statement {
    effect = "Allow"

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:BatchGetBuilds"
    ]

    resources = ["arn:aws:codebuild:eu-west-1:*"]
  }
}

# IAM role and policy for CodeBuild
resource aws_iam_role codebuild_frontend {
  name                 = "${var.application_name}-codebuild-${var.environment}"
  assume_role_policy   = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild" {
   statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  } 
}

resource aws_iam_policy codebuild_frontend {
  name        = "${var.application_name}-codebuild-${var.environment}"
  description = "Allow codebuild deployments"
  policy      = data.aws_iam_policy_document.codebuild_frontend.json
}

resource aws_iam_role_policy_attachment codebuild_frontend {
  role       = aws_iam_role.codebuild_frontend.name
  policy_arn = aws_iam_policy.codebuild_frontend.arn
}

data aws_iam_policy_document codebuild_frontend {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission"
    ]

    resources = ["arn:aws:logs:eu-west-1:*","arn:aws:ec2:eu-west-1:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:UpdateReportGroup",
      "codebuild:ListReportsForReportGroup",
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:ListReports",
      "codebuild:DeleteReport",
      "codebuild:ListReportGroups",
      "codebuild:BatchPutTestCases"
    ]

    resources = [
      "arn:aws:codebuild:eu-west-1:*"
    ]
  }
}
