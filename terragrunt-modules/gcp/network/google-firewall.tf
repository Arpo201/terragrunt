module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.provider_info.project_id
  network_name = module.vpc.network_name

  rules = [
    {
      name                    = "${var.network_name}-allow-default"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["22", "3389"]
        },
        {
          protocol = "icmp"
          ports    = []
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "${var.network_subnet_name}-allow-http"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["http-server"]
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["80"]
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "${var.network_subnet_name}-allow-https"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["https-server"]
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "${var.network_subnet_name}-allow-openvpn"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["openvpn"]
      target_service_accounts = null
      allow = [
        {
          protocol = "udp"
          ports    = ["1194"]
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "${var.network_subnet_name}-allow-internal"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = [var.network_subnet_ip]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = []
        },
        {
          protocol = "udp"
          ports    = []
        },
        {
          protocol = "icmp"
          ports    = []
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]

  depends_on = [
    module.vpc
  ]
}
