resource "vsphere_virtual_machine" "master_node" {
  count                      = var.master_node.num
  name                       = "${var.master_node.name}_${count.index + 1}"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.master_node.cpus
  memory                     = var.master_node.memory
  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.master_node.disk_size
  }

  clone {
    template_uuid = var.vm_template_uuid.node
  }

  vapp {
    properties = {
      "guestinfo.ignition.config.data" = jsonencode(jsondecode(data.ct_config.master_ignition[count.index].rendered))
    }
  }
}

resource "vsphere_virtual_machine" "worker_node" {
  count                      = var.worker_node.num
  name                       = "${var.worker_node.name}_${count.index + 1}"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.worker_node.cpus
  memory                     = var.worker_node.memory
  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0


  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.worker_node.disk_size
  }

  clone {
    template_uuid = var.vm_template_uuid.node
  }

  vapp {
    properties = {
      "guestinfo.ignition.config.data" = jsonencode(jsondecode(data.ct_config.worker_ignition[count.index].rendered))
    }
  }
}

resource "vsphere_virtual_machine" "master_lb" {
  count                      = var.master_lb.num
  name                       = "${var.master_lb.name}_${count.index + 1}"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.master_lb.cpus
  memory                     = var.master_lb.memory
  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0
  # reboot_required            = true

  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.master_lb.disk_size
  }

  clone {
    template_uuid = var.vm_template_uuid.lb
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      user-data = base64encode(templatefile(
        "${path.module}/templates/user-data-ubuntu-master-lb.yaml",
        {
          ip         = "${var.master_lb.ip[count.index]}/${var.master_lb.subnetmask}"
          gateway_ip = var.master_lb.gateway_ip
          ssh_keys   = var.master_lb.ssh_keys
          target_ips = var.master_node.ip
        }
      ))
    }
  }
}

resource "vsphere_virtual_machine" "worker_lb" {
  count                      = var.worker_lb.num
  name                       = "${var.worker_lb.name}_${count.index + 1}"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.worker_lb.cpus
  memory                     = var.worker_lb.memory
  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0


  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.worker_lb.disk_size
  }

  clone {
    template_uuid = var.vm_template_uuid.lb
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      user-data = base64encode(templatefile(
        "${path.module}/templates/user-data-ubuntu-worker-lb.yaml",
        {
          ip         = "${var.worker_lb.ip[count.index]}/${var.worker_lb.subnetmask}"
          gateway_ip = var.worker_lb.gateway_ip
          ssh_keys   = var.worker_lb.ssh_keys
          target_ips = var.worker_node.ip
        }
      ))
    }
  }
}

resource "vsphere_virtual_machine" "storage" {
  count                      = 1
  name                       = "${var.storage_vm.name}_${count.index + 1}"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  num_cpus                   = var.storage_vm.cpus
  memory                     = var.storage_vm.memory
  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0


  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.storage_vm.disk_size
  }

  clone {
    template_uuid = var.vm_template_uuid.lb
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      user-data = base64encode(templatefile(
        "${path.module}/templates/user-data-ubuntu-storage.yaml",
        {
          ip         = "${var.storage_vm.ip[count.index]}/${var.storage_vm.subnetmask}"
          gateway_ip = var.storage_vm.gateway_ip
          ssh_keys   = var.storage_vm.ssh_keys
          target_ips = var.storage_vm.ip
        }
      ))
    }
  }
}