locals {
  ######################################################################################
  # Set custom network configuration if network already exist (create_network = false)
  create_network              = true
  custom_vpc_name             = "project_a-dev-test-terragrunt-network"
  custom_vpc_subnetwork_names = ["project_a-dev-network-subnet"]
  custom_vpc_subnets_secondary_ranges = [
    [
      {
        ip_cidr_range = "10.58.0.0/24"
        range_name    = "project_a-dev-network-subnet-secondary-pod"
      },
      {
        ip_cidr_range = "10.59.0.0/24"
        range_name    = "project_a-dev-network-subnet-secondary-service"
      },
    ],
  ]
  ######################################################################################

  ######################################################################################
  # Set custom cluster configuration if cluster already exist (create_cluster = false)
  create_cluster        = true
  custom_cluster_name   = "project_a-dev-test-terragrunt-cluster"
  custom_endpoint       = "34.126.66.37"
  custom_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FUERX0K"
  ######################################################################################


}
