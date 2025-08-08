# find vulnerabilities and misconfigurations by trivy
trivy:
    trivy fs .
    trivy config .

# get connection string of all regions of Azure CosmosDB
cosmos:
    sh ./scripts/get-cosmosdb.sh

# get credentials of AKS and merge to "~/.kube/config"
aks:
    sh ./scripts/get-kubernetes.sh
