terraform {
  # s3 backend docs:
  # https://developer.hashicorp.com/terraform/language/backend/s3
  backend "s3" {
    bucket                      = "tf-states"
    key                         = "multi-region-aks/terraform.tfstate"
    endpoints                   = { s3 = "https://00c0277ef0d444bf5c13b03cf8a33405.r2.cloudflarestorage.com" }
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = true
  }

  # version constraints docs:
  # https://developer.hashicorp.com/terraform/language/expressions/version-constraints
  required_version = ">= 1.10"
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.2.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
  }
}

# carlpett/sops provider docs: 
# https://registry.terraform.io/providers/carlpett/sops/latest/docs
provider "sops" {}

# hashicorp/azurerm provider docs:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  client_id       = local.client_id
  client_secret   = local.client_secret
  tenant_id       = local.tenant_id
  subscription_id = local.subscription_id
}
