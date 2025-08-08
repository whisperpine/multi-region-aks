#!/bin/sh

# Purpose: get connection string of all regions of Azure CosmosDB.
# Usage: sh path/to/get-cosmosdb.sh
# Dependencies: opentofu, azure-cli
# Date: 2025-08-08
# Author: Yusong

# Prerequisites:
# - azure-cli (the "az" command) has already logged in with adequate permission.
# - infrastructure has already been deployed (namely "tofu apply").

set -e

# The root directory of this project.
project_root=$(git rev-parse --show-toplevel)
# Make sure the working directory is correct.
cd "$project_root/infra" || exit 1

rg_name_prefix=$(tofu output -raw resource_group_name_prefix)
cosmosdb_account_name=$(tofu output -raw cosmosdb_account_name)
rg_name="${rg_name_prefix}-$(tofu output -raw main_location)"
# The possible arguments of --type: connection-strings, keys, read-only-keys
raw_connection_string=$(az cosmosdb keys list --name "$cosmosdb_account_name" \
    --resource-group "$rg_name" \
    --type connection-strings \
    --query "connectionStrings[?keyKind == 'Primary'].connectionString" |
    tr -d '[]" \n')
# echo "$raw_connection_string"

locations=$(az cosmosdb show --name "$cosmosdb_account_name" \
    --resource-group "$rg_name" \
    --query "locations[].locationName" |
    tr -d '[]' | sed "s/  \"/\"/g" | sed "s/ /-/g" | tr ',' ' ' | tr -d '"\n')
# echo "$locations"

raw_hostname="${cosmosdb_account_name}.mongo.cosmos.azure.com"
for location in $locations; do
    append_location=$(echo "$location" | tr '-' ' ')
    host_location=$(echo "$location" | tr -d '-' | tr '[:upper:]' '[:lower:]')
    hostname="${cosmosdb_account_name}-${host_location}.mongo.cosmos.azure.com"
    echo "$raw_connection_string" | sed "s/${raw_hostname}/${hostname}/g" | sed "s/$/${append_location}/g"
    echo
done

# # Run this command to regenerate a given key (only useful when a certain key is compromised).
# # The possible arguments of --key-kind: primary, primaryReadonly, secondary, secondaryReadonly
# az cosmosdb keys regenerate --name "$cosmosdb_account_name" \
#     --resource-group "$rg_name" \
#     --key-kind xxx
