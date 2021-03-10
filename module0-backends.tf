# 1. Create user 'aws-terraform-training'

# 2. Add Security keys into env variables
# https://console.aws.amazon.com/iam/home?region=eu-central-1#/users/aws-terraform-training?section=security_credentials
# Create security accessKeyId

# 3. Check
# read ~/.aws/credentials

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  #access_key = ""
  #secret_key = ""
}

