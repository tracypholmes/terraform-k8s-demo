terraform {
  required_version = "~> 0.13"
  required_providers {
    mycloud = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  host = "https://kubernetes:6443"
}