output "vpc_name" {
  value = module.vpc.network_name
}

output "vpc_subnetwork_names" {
  value = module.vpc.subnets_names
}

output "vpc_subnets_secondary_ranges" {
  value = module.vpc.subnets_secondary_ranges
}

