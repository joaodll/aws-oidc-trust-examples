provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

output "aws_identity" {
  value = data.aws_caller_identity.current
}