#!/bin/sh

# Purpose: get credentials of AKS and merge to "~/.kube/config"
# Usage: sh path/to/get-kubernetes.sh
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
k8s_name_prefix=$(tofu output -raw kubernetes_cluster_name_prefix)

locations_json=$(tofu output -json location_list)
locations=$(echo "$locations_json" | tr -d '[]"' | tr ',' ' ')
for location in $locations; do
    rg_name="$rg_name_prefix-$location"
    k8s_name="$k8s_name_prefix-$location"
    az aks get-credentials --resource-group "$rg_name" --name "$k8s_name"
done
