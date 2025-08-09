# Multi-region AKS

[![GitHub License](https://img.shields.io/github/license/whisperpine/multi-region-aks)](https://github.com/whisperpine/multi-region-aks/blob/main/LICENSE)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/whisperpine/multi-region-aks/checks.yml?logo=github&label=checks)](https://github.com/whisperpine/multi-region-aks/actions/workflows/checks.yml)
[![GitHub deployments](https://img.shields.io/github/deployments/whisperpine/multi-region-aks/infra-default?logo=github&label=deployment)](https://github.com/whisperpine/multi-region-aks/deployments/infra-default)
[![GitHub Release](https://img.shields.io/github/v/release/whisperpine/multi-region-aks?logo=github)](https://github.com/whisperpine/multi-region-aks/releases)

Multi-region Azure Kubernetes Service (AKS) managed by Terraform or Opentofu.

```mermaid
flowchart TD
  subgraph Region A
    ka("K8s Cluster A")
  end
  subgraph Region B
    kb("K8s Cluster B")
  end
  subgraph Region C
    kc("K8s Cluster C")
  end
  subgraph CosmosDB with Multi-region Writes
    ca("Endpoint A")
    cb("Endpoint B")
    cc("Endpoint C")
  end
  ka -.- ca
  kb -.- cb
  kc -.- cc
```
