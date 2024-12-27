include "root" {
  path = find_in_parent_folders()
}

include "cluster" {
  path   = find_in_parent_folders("cluster.hcl")
  expose = true
}

include "k8s_cluster_provider" {
  path = find_in_parent_folders("${dirname(find_in_parent_folders("account.hcl"))}/_common/k8s_cluster_provider.hcl")
}

include "kubernetes_provider" {
  path = find_in_parent_folders("${dirname(find_in_parent_folders("account.hcl"))}/_common/kubernetes_provider.hcl")
}

inputs = {
}
