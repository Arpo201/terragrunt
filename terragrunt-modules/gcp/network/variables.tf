variable "provider_info" {
  type = object({
    cloud_provider = optional(string, "gcp")
    credentials    = string
    project_id     = string
    region         = string
    zone           = string
  })
  description = "Information for use gcp"
}

variable "network_name" {
  type        = string
  description = "google network name"
}

variable "network_subnet_name" {
  type        = string
  description = "google subnet name"
}

variable "network_subnet_ip" {
  type        = string
  description = "google subnet ip"
}

variable "network_secondary_ranges_pod_name" {
  type        = string
  description = "google secondary ranges pod name"
}

variable "network_secondary_pod_ip" {
  type        = string
  description = "google secondary pod ip"
}

variable "network_secondary_ranges_service_name" {
  type        = string
  description = "google secondary ranges service name"
}

variable "network_secondary_service_ip" {
  type        = string
  description = "google secondary service ip"
}

variable "cloud_router_name" {
  type        = string
  description = "google cloud router name"
}
