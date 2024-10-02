terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }

    github = {
      source  = "hashicorp/github"
      version = "4.14.0"
    }
  }
}