data "vsphere_datacenter" "datacenter" {
  name = var.data_source.datacenter_name
}

data "vsphere_datastore" "datastore" {
  name          = var.data_source.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.data_source.resource_pool_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.data_source.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
