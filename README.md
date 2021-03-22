# Automate React Deployments to S3 & CloudFront
This repository contains the source code to create a CI/CD pipeline for a React application in AWS. The pipeline pulls the source code from GitHub and run tests against the application before deploying it to an S3 bucket for static site hosting. The site will then be distributed using CloudFront which will point to the S3 bucket. All of the infrastructure is built using Terraform. In addition, I make use of Terragrunt to create this setup for multiple environments in a DRY approach.

## Technical Architecture Diagram
![Alt text](./architecture-diagram.png?raw=true "Technical Architecture Diagram")

## The Concept of Backend State & State Locking
### Backend State
Backend state enables you to persist the state of your deployed infrastructure. The 
state can either be stored locally or remotely. 
The state is persisted in a file that contains a custom JSON format that records a mapping from the Terraform resources in your configuration files to the representation of those resources in the real world.

If you’re using Terraform for a personal project, storing state in a local terraform.tfstate file works just fine.

How does this work in a team?
Shared storage for state filesTo be able to use Terraform to update your infrastructure, each of your team members needs access to the sameTerraform state files. That means you need to store those files in a shared location.

A common practice is to store the backend state remotely like an AWS S3 bucket. The backend state allows Terraform to compare desired state (what you want to deploy) with current or existing state (what has already been deployed). 

### State Locking
If you're working in a team, you will have different people acting on the current or existing state of the infrastructure. As you can imagine, this can lead to clashes in the desired state. To circumvent this issue or solve this problem, we have the concept of state locking. What this enables is for any user deploying infrastructure to acquire what is known as a state lock, which will lock the current or existing state from being updated by anyone other than the user who has acquired the state lock. Once the operation has completed and the state has been updated, the lock will be released. This process happens automatically when running `terraform apply`.
This way, when Mando is running an `apply` operation, Tumbone can't act on the state till Mando's operation is done. DynamoDB is a good tool to maintain the state locking mechanism.

### Chicken & Egg Situation
You may have already thought of this, but if you want implement remote backend state and state locking with S3 and DynamoDB, you have to create them manually and not using Terraform, because Terraform requires backend state and optionally state locking to be created beforehand.

## Getting Started
The first step to create the infrastructure with Terraform is to ensure that backend remote state has been configured with a bucket in s3 that stores the state, and a table in the DynamoDB that stores the state lock.

### Create S3 Bucket for Backend State
The S3 bucket can either be created manually in the Console or using the following CLI command:
`aws s3api create-bucket --bucket devopsjs-terraform-state --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1`

### Create DynamoDB Table for State Locking
The DynamoDB table can either be created manually in the Console or using the following CLI command:
`aws dynamodb create-table --table-name devopsjs-terraform-lock-table --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1`
