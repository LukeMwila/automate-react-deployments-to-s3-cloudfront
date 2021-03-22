# GitHub secrets
data "aws_secretsmanager_secret" "github_secret" {
  name = var.github_secret_name
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_secret.id
}

# Frontend Pipeline
module "frontend_pipeline" {
  source = "./frontend_pipeline"
  application_name = var.application_name
  s3_bucket_destination = "${var.application_name}-${var.environment}"
  pipeline_bucket_name = "${var.application_name}-codepipeline"
  codebuild_bucket_name = "${var.application_name}-codebuild"
  github_org = "LukeMwila"
  repository_name = "automate-react-deployments-to-s3-cloudfront"
  branch_name = var.branch_name
  environment     = var.environment
  github_token = jsondecode(data.aws_secretsmanager_secret_version.github_token.secret_string)["GitHubPersonalAccessToken"]
}