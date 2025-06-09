terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "devops-proj-s3-backend"
    key    = "dev_statefile/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.region
}
