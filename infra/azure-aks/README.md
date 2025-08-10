# Azure AKS Module

Multi-region Azure Kubernetes Service (AKS).

## Virtual Machine Series

Series using ARM64 processors:

| Series | vCPU:GB |
| - | - |
| Dpls_v6 | 1:2 |
| Dps_v6 | 1:4 |
| Eps_v6 | 1:8 |

For example:

- In Dps_v6 Series, Standard_D2ps_v6: 2vCPU, 8GB.
- In Dps_v6 Series, Standard_D4ps_v6: 4vCPU, 16GB.

VMs using ARM architecture are preferred due to lower costs.
Developers should build container images compatible with this architecture,
namely `linux/arm64`.

## Autoscaling Groups

The max node count is constrained by both `max_count` below and [Quotas](https://learn.microsoft.com/en-us/azure/quotas/quotas-overview).

```hcl
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  min_count           = 0
  max_count           = 25
  enable_auto_scaling = true
  # ...
}
```

Quota is bound to a specific Azure Subscription, and independent across regions.
Thus be careful to the subscription and region that a quota belongs to.

| Quota | Connotation |
| - | - |
| Total Regional vCPUs | The max vCPU (not including Spot instances) |
| Total Regional Spot vCPUs | The max vCPU of Spot instances |
| Standard DPLSv6 Family vCPUs | The max vCPU of DPLSv6 Series |

You can *request adjustment* on the Quotas page of Azure Portal.
This may take several minutes, and if it fails, you have to reach out to
customer support which may take 1 week.

To inspect the quotas, besides Azure Portal, the following commands are handy:

```sh
# List the usage of vm related quotas in West Europe region.
az vm list-usage --location "West Europe" --output table
# An alternative is to use "westeurope" instead of "West Europe".
az vm list-usage --location "westeurope" --output table
```

## Spot Instances

Spot instances are much cheaper compared to regular instances with a minimum of
10% costs. The downside is that spot instances can be evicted unexpectedly (the
eviction rate is typically 0-5%).

## Node Labels and Taints

Kubernetes *node labels* and *taints* are configured to distinguish between
*Regular* and *Spot* node pools, while backend deployments apply *node affinity*
and *taint tolerations* to ensure workloads are scheduled appropriately.

```hcl
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }
  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]
  # ...
}
```

An example of the corresponding kubernetes resource configuration:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: spot-example
spec:
  containers:
    - name: spot-example
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          # Be inclined to schedule these pods on the node with this label.
          - matchExpressions:
              - key: "kubernetes.azure.com/scalesetpriority"
                operator: In
                values:
                  - "spot"
  tolerations:
    # Allow these pods to be scheduled on the node with this taint.
    - key: "kubernetes.azure.com/scalesetpriority"
      operator: "Equal"
      value: "spot"
      effect: "NoSchedule"
```
