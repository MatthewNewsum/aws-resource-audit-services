terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create a minimal Amplify app
resource "aws_amplify_app" "test_app" {
  name         = "test-amplify-app"
  platform     = "WEB"
  
  # Minimal build settings required
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        build:
          commands: []
      artifacts:
        baseDirectory: /
        files:
          - '**/*'
  EOT

  # Minimal IAM role for Amplify
  iam_service_role_arn = aws_iam_role.amplify_role.arn
}

# Create minimal IAM role for Amplify
resource "aws_iam_role" "amplify_role" {
  name = "test-amplify-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      }
    ]
  })
}

# Attach minimal policy to the role
resource "aws_iam_role_policy" "amplify_policy" {
  name = "test-amplify-policy"
  role = aws_iam_role.amplify_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Output the Amplify app details
output "amplify_app_id" {
  value = aws_amplify_app.test_app.id
}

output "amplify_app_default_domain" {
  value = aws_amplify_app.test_app.default_domain
}

output "amplify_app_arn" {
  value = aws_amplify_app.test_app.arn
}