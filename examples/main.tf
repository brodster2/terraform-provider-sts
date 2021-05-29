terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.42.0"
    }
    sts = {
      source  = "github.com/brodster22/sts"
      version = "0.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "sts" {}

data "aws_caller_identity" "current" {

}

resource "aws_iam_role" "test" {
  name_prefix = "testing"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
      },
    ]
  })
  inline_policy {}
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

data "sts_assume_role" "creds" {
  role_arn = aws_iam_role.test.arn
}

resource "null_resource" "caller_identity" {
  triggers = {
    "role" = aws_iam_role.test.arn
  }

  provisioner "local-exec" {
    environment = {
      AWS_ACCESS_KEY_ID     = data.sts_assume_role.creds.access_key_id
      AWS_SECRET_ACCESS_KEY = data.sts_assume_role.creds.secret_access_key
      AWS_SESSION_TOKEN     = data.sts_assume_role.creds.session_token
      AWS_REGION            = "eu-west-1"
    }
    command = "aws sts get-caller-identity --output text"
  }
}
