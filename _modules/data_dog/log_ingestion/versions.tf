terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 2.10, < 3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.35"
    }
  }
}