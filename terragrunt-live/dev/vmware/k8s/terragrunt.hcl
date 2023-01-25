terraform {
  source = "${get_path_to_repo_root()}/terragrunt-modules/${include.root.locals.provider_info.cloud_provider}/k8s"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "vm_dependency" {
  path = find_in_parent_folders("${dirname(find_in_parent_folders("account.hcl"))}/_common/vm_dependency.hcl")
}

inputs = {
  kubespray_inventory_name = "project_A_cluster"
  cluster_name             = "${include.root.locals.name_prefix}-project-cluster"
  kube_version             = "v1.24.6"
}
