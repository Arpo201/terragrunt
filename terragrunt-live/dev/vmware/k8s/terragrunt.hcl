terraform {
  // Output example : source = "/Users/test/terragrunt/terragrunt-modules/local/test-variables"
  source = "${replace(replace(get_terragrunt_dir(), "terragrunt-live", "terragrunt-modules"), "${include.root.locals.environment}", "")}"
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
