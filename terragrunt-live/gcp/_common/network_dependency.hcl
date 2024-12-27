locals {
  env_vars                            = read_terragrunt_config("${dirname(find_in_parent_folders("account.hcl"))}/_common/_env.hcl")
  create_network                      = local.env_vars.locals.create_network
  custom_vpc_name                     = local.env_vars.locals.custom_vpc_name
  custom_vpc_subnetwork_names         = local.env_vars.locals.custom_vpc_subnetwork_names
  custom_vpc_subnets_secondary_ranges = local.env_vars.locals.custom_vpc_subnets_secondary_ranges
}

dependency "network" {
  skip_outputs = !local.create_network # if true, use mocks be output

  # result: /terragrunt-live/dev/gcp/network
  config_path = "${dirname(find_in_parent_folders("account.hcl"))}/network"

  mock_outputs = {
    vpc_name             = "fake-network-name",
    vpc_subnetwork_names = ["fake-network-subnet-names"]
    vpc_subnets_secondary_ranges = [
      [
        {
          ip_cidr_range = "fake-network-subnet-secondary-pod-ip"
          range_name    = "fake-network-subnet-secondary-pod-name"
        },
        {
          ip_cidr_range = "fake-network-subnet-secondary-service-ip"
          range_name    = "fake-network-subnet-secondary-service-name"
        },
      ],
    ]

  }
}

inputs = {
  vpc_name                     = local.create_network ? dependency.network.outputs.vpc_name : local.custom_vpc_name
  vpc_subnetwork_names         = local.create_network ? dependency.network.outputs.vpc_subnetwork_names : local.custom_vpc_subnetwork_names
  vpc_subnets_secondary_ranges = local.create_network ? dependency.network.outputs.vpc_subnets_secondary_ranges : local.custom_vpc_subnets_secondary_ranges
}
