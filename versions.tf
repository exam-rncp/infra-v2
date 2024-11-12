
terraform {
  required_version = ">= 1.3.2"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.30.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.57"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.15"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.4, <=3.32"
    }
  }
}
