# ---------------- VM master node -----------------

data "ct_config" "master_ignition" {
  count = var.master_node.num
  content = templatefile(
    "${path.module}/templates/user-data-fedoraCoreOS-node.fcc",
    {
      ip         = var.master_node.ip[count.index]
      subnet     = var.master_node.subnetmask
      gateway_ip = var.master_node.gateway_ip
      dns        = var.master_node.dns
      ssh_keys   = var.master_node.ssh_keys
    }
  )
  strict       = true
  pretty_print = false
}
# --------------------------------------------------

# ---------------- VM worker node -----------------

data "ct_config" "worker_ignition" {
  count = var.worker_node.num
  content = templatefile(
    "${path.module}/templates/user-data-fedoraCoreOS-node.fcc",
    {
      ip         = var.worker_node.ip[count.index]
      subnet     = var.worker_node.subnetmask
      gateway_ip = var.worker_node.gateway_ip
      dns        = var.worker_node.dns
      ssh_keys   = var.worker_node.ssh_keys
    }
  )
  strict       = true
  pretty_print = false
}
# --------------------------------------------------
