output "cosmosdb_account_name" {
  description = "the account name of CosmosDB"
  value       = azurerm_cosmosdb_account.db.name
}
