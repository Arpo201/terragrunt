dependency "vm" {
  # skip_outputs = !local.create_network # if true, use mocks be output

  # result: /terragrunt-live/dev/vmware/vm
  config_path = "${dirname(find_in_parent_folders("account.hcl"))}/vm"

  mock_outputs = {
    master_node = {}
    worker_node = {}
    master_lb   = {}
    worker_lb   = {}
    # {
    #   name       = "fake-master_node"
    #   num        = 2
    #   cpus       = 2
    #   memory     = 4096
    #   disk_size  = 10
    #   ip         = ["10.33.71.1", "10.33.71.2", "10.33.71.3"]
    #   subnetmask = "16"
    #   gateway_ip = "10.33.255.254"
    #   dns        = "8.8.8.8"
    #   ssh_keys   = []
    # }

  }
}

inputs = {
  master_node = dependency.vm.outputs.master_node
  worker_node = dependency.vm.outputs.worker_node
  master_lb   = dependency.vm.outputs.master_lb
  worker_lb   = dependency.vm.outputs.worker_lb
}
