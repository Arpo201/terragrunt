terraform {
  source = "${get_path_to_repo_root()}/terragrunt-modules/${include.root.locals.provider_info.cloud_provider}/vm"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  ssh_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDd3Y/sPI+/MF4L8JV3rhwDMID3h8BI5BeB8Kmvbkztqng67fqmE9DN5rkfb75EQ== test@windows",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCC45455c7ntiXDNzBnnZaC9DCgSX5JhR9As38wfbJGd5yG2T1vt0TulcGEkHWkJ3 test@Ubuntu",
  ]
}

inputs = {
  data_source = {
    datacenter_name      = "site.company.in.th"
    datastore_name       = "vsanDatastore"
    compute_cluster_name = "company Site"
    resource_pool_name   = "ProjectA"
    network_name         = "site2-external_33"
  }

  vm_template_uuid = {
    node = "74ed2c8c-6c54-41ed-abec-943f9f75811d"
    lb   = "a9f7aa4d-cc7e-4a57-99c3-112cd88815cd"
    storage   = "a9f7aa4d-cc7e-4a57-99c3-112cd88815cd"
  }

  master_node = {
    name       = "master_node"
    num        = 3
    cpus       = 4
    memory     = 4096 # MB
    disk_size  = 50 # GB
    ip         = ["10.33.81.1", "10.33.81.2", "10.33.81.3"]
    subnetmask = "16"
    gateway_ip = "10.33.255.254"
    dns        = "8.8.8.8"
    ssh_keys = local.ssh_keys
  }

  worker_node = {
    name       = "worker_node"
    num        = 3
    cpus       = 8
    memory     = 4096 # MB
    disk_size  = 100 # GB
    ip         = ["10.33.82.1", "10.33.82.2", "10.33.82.3"]
    subnetmask = "16"
    gateway_ip = "10.33.255.254"
    dns        = "8.8.8.8"
    ssh_keys = local.ssh_keys
  }

  master_lb = {
    name       = "master_lb"
    num        = 1
    cpus       = 2
    memory     = 4096 # MB
    disk_size  = 20 # GB
    ip         = ["10.33.83.1"]
    subnetmask = "16"
    gateway_ip = "10.33.255.254"
    dns        = "8.8.8.8"
    ssh_keys = local.ssh_keys
  }

  worker_lb = {
    name       = "worker_lb"
    num        = 1
    cpus       = 4
    memory     = 4096 # MB
    disk_size  = 20 # GB
    ip         = ["10.33.83.2"]
    subnetmask = "16"
    gateway_ip = "10.33.255.254"
    dns        = "8.8.8.8"
    ssh_keys = local.ssh_keys
  }

  storage_vm = {
    name       = "storage"
    num        = 1
    cpus       = 4
    memory     = 4096 # MB
    disk_size  = 200 # GB
    ip         = ["10.33.83.11"]
    subnetmask = "16"
    gateway_ip = "10.33.255.254"
    dns        = "8.8.8.8"
    ssh_keys = local.ssh_keys
  }

}
