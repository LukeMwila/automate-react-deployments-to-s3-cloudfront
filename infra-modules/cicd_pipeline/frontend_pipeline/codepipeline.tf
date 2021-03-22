resource aws_codepipeline main {
  name = "${var.application_name}-frontend-${var.environment}"
  role_arn = aws_iam_role.codepipeline_frontend.arn 

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type = "S3"
  }

  stage {
    name = "Source"
    action {
      name = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner                = var.github_org
        Repo                 = var.repository_name
        PollForSourceChanges = "false"
        Branch               = var.branch_name
        OAuthToken           = var.github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version = "1"

      configuration = {
        ProjectName   = aws_codebuild_project.frontend_build_project.arn
        PrimarySource = "SourceArtifact"
      }

      run_order = 2
    }
  }

  tags = {
    Name = "${var.application_name}-frontend-codepipeline-${var.environment}"
    Environment = var.environment
  }
}