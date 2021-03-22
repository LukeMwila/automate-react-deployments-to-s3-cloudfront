variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "region" {
  description = "aws region to deploy to"
  type        = string
}

variable "application_name" {
  description = "The name of the application"
  type = string
}

variable "environment" {
  description = "Applicaiton environment"
  type = string
}

variable "github_secret_name" {
  type        = string
}

variable "branch_name" {
  type = string
}