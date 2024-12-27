terraform {
  // Output example : source = "/Users/test/terragrunt/terragrunt-modules/local/test-variables"
  source = "${replace(replace(get_terragrunt_dir(), "terragrunt-live", "terragrunt-modules"), "${include.root.locals.env_vars.environment}", "")}"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env_vars" {
  path   = "${dirname(find_in_parent_folders("account.hcl"))}/_common/_env.hcl"
  expose = true
}

generate "google_beta_provider" {
  path      = "google_beta_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google-beta" {
      project     = "${include.root.locals.provider_info.project_id}"
      region      = "${include.root.locals.provider_info.region}"
      zone        = "${include.root.locals.provider_info.zone}"
      credentials = file("${include.root.locals.provider_info.credentials}")
    }
  EOF
}

inputs = {
  network_name                          = "${include.root.locals.name_prefix}-test-terragrunt-network"
  cloud_router_name                     = "${include.root.locals.name_prefix}-test-terragrunt-router"
  network_subnet_name                   = "${include.root.locals.name_prefix}-network-subnet"
  network_subnet_ip                     = "10.1.0.0/24"
  network_secondary_ranges_pod_name     = "${include.root.locals.name_prefix}-network-subnet-secondary-pod"
  network_secondary_pod_ip              = "10.2.0.0/16"
  network_secondary_ranges_service_name = "${include.root.locals.name_prefix}-network-subnet-secondary-service"
  network_secondary_service_ip          = "10.3.0.0/16"
}

skip = !include.env_vars.locals.create_network || !include.env_vars.locals.create_cluster
