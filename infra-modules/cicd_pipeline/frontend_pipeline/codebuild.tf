resource aws_codebuild_project frontend_build_project {
  name          = "${var.application_name}_frontend_${var.environment}"
  description   = "codebuild stage"
  service_role  = aws_iam_role.codebuild_frontend.arn
  build_timeout = var.build_timeout

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.codebuild_bucket_name}-${var.environment}/_cache/archives"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "client-application/buildspec.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = var.codebuild_image
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ENV"
      value = var.environment
    }

    environment_variable {
      name  = "S3_BUCKET_DESTINATION"
      value = var.s3_bucket_destination
    }
  }

  tags = {
    Name = "${var.application_name}-frontend-codebuild-${var.environment}"
    Environment = var.environment
  }
}