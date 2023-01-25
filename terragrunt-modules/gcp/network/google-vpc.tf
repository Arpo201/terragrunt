module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0.0"

  project_id   = var.provider_info.project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name           = var.network_subnet_name
      subnet_ip             = var.network_subnet_ip
      subnet_region         = var.provider_info.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    }
  ]

  secondary_ranges = {
    "${var.network_subnet_name}" = [
        {
            range_name    = var.network_secondary_ranges_pod_name
            ip_cidr_range = var.network_secondary_pod_ip
        },
        {
            range_name    = var.network_secondary_ranges_service_name
            ip_cidr_range = var.network_secondary_service_ip
        },
    ]
  }
}
