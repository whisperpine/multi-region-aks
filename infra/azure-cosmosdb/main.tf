terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account
resource "azurerm_cosmosdb_account" "db" {
  name                = var.cosmosdb_name
  location            = var.cosmosdb_location
  resource_group_name = var.resource_group_name
  kind                = "MongoDB"
  offer_type          = "Standard"
  free_tier_enabled   = var.free_tier_enabled

  mongo_server_version             = "7.0" # Options: "7.0", "6.0", "5.0", "4.2".
  automatic_failover_enabled       = true  # Refer to failover_priority below.
  multiple_write_locations_enabled = true  # It reduces write latency.
  # It must be true if virtual_network_rule is used.
  # It can be false if private_end_point is used instead.
  public_network_access_enabled = true # Allow public access (for azure portal visualization).

  # A set of IP address ranges in CIDR form to be included as the allowed list
  # of client IPs. We probably want to use IPs from Azure Portal:
  # https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall
  # ip_range_filter = "xxx"

  # It must be true, so that virtual_network_rule can be configured.
  is_virtual_network_filter_enabled = true
  # Specifies a virtual_network_rule block as defined below, used to define
  # which subnets are allowed to access this CosmosDB account.
  dynamic "virtual_network_rule" {
    for_each = var.subnet_id_list
    content {
      id = virtual_network_rule.value
    }
  }

  capacity {
    # The total throughput limit imposed on this Cosmos DB account (RU/s). -1 means no limit.
    # The first 1000 RU/s and 25 GB of storage in the account is free if free tier is enabled.
    total_throughput_limit = var.throughput_limit
  }

  backup {
    # If enable_multiple_write_locations is true, "Continuous" cannot be used.
    type                = "Periodic" # Options: "Periodic" or "Continuous"
    storage_redundancy  = "Geo"      # Option: "Geo", "Local", "Zone"
    interval_in_minutes = 480
    retention_in_hours  = 16

    # If the type is set to "Periodic", it's free to have no more than 2 backups.
    # Otherwise the exceeded backups will be charged $0.15/month/GB.
  }

  # https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels
  consistency_policy {
    # Options: Strong, BoundedStaleness, Session, ConsistentPrefix, Eventual
    consistency_level = "Eventual"
    # If set to "BoundedStaleness", the following two lines must also be configured:
    # max_interval_in_seconds = 300
    # max_staleness_prefix    = 100000
  }

  dynamic "capabilities" {
    for_each = ["EnableMongo"]
    content {
      name = capabilities.value
    }
  }

  dynamic "geo_location" {
    for_each = var.location_list
    content {
      # When failover_priority is set to 0, the location is the main location.
      failover_priority = geo_location.key
      location          = geo_location.value
    }
  }
}
