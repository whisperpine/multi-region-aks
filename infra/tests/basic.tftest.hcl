# Provider "carlpett/sops" docs:
# https://registry.terraform.io/providers/carlpett/sops/latest/docs
provider "sops" {}

# Provider "hashicorp/azurerm" docs:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  client_id       = local.client_id
  client_secret   = local.client_secret
  tenant_id       = local.tenant_id
  subscription_id = local.subscription_id
}

# Test the root module.
run "test_root_module" {
  command = plan
}
