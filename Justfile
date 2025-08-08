# find vulnerabilities and misconfigurations by trivy
trivy:
    trivy fs .
    trivy config .

# get credentials of AKS and merge to "~/.kube/config"
aks:
    sh ./scripts/get-kubernetes.sh
