locals {
  kubespray_inventory_config = templatefile("${path.module}/templates/kubespray-inventory.ini.tftpl", {
    master_ips = var.master_node.ip,
    worker_ips = var.worker_node.ip
  })

  kubespray_all_config = templatefile("${path.module}/templates/kubespray-all.yml.tftpl", {
    master_lb_ip = var.master_lb.ip[0]
  })

  kubespray_k8s_cluster_config = templatefile("${path.module}/templates/kubespray-k8s-cluster.yml.tftpl", {
    cluster_name = var.cluster_name
    kube_version = var.kube_version
  })

  vm_ip_list = concat(var.master_node.ip, var.worker_node.ip, var.master_lb.ip, var.worker_lb.ip)
}

resource "random_id" "id" {
  keepers = {
    force_renew = "${timestamp()}"
  }
  byte_length = 8
}

resource "local_file" "kubespray_inventory_config" {
  content  = local.kubespray_inventory_config
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/inventory.ini"
}

resource "local_file" "kubespray_all_config" {
  content  = local.kubespray_all_config
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/group_vars/all/all.yml"
}

resource "local_file" "kubespray_k8s_cluster_config" {
  content  = local.kubespray_k8s_cluster_config
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/group_vars/k8s_cluster/k8s-cluster.yml"
}

resource "local_file" "setStrictHostKeyChecking" {
  content  = <<-EOF
    %{for ip in local.vm_ip_list~}
    Host ${ip}
          StrictHostKeyChecking no
    %{endfor~}

  EOF
  filename = "${pathexpand("~")}/.ssh/config"
}

resource "null_resource" "check_vms" {
  provisioner "local-exec" {
    command     = <<-EOF
      vm_ip_list="${join(" ", local.vm_ip_list)}"
      round=1
      while [ $round -ne 1 ]
      do
        echo "Verify vm round: $round"
        isLoop=1
        while [ $isLoop -eq 1 ]
        do
          for ip in $vm_ip_list
            do
              ssh project_a@$ip command ls /etc | grep "user-data-finished.txt"
              if [ "$?" -eq 0 ]
              then
                  isLoop=0
                  echo "$ip: OK!"
              else
                  isLoop=1
                  echo "$ip: Nope!"
                  break
              fi
            done
          done
          sleep 1m
          round=$((round+1))
      done

    EOF
    interpreter = ["/bin/bash", "-c"]
    # when        = create
  }
  lifecycle {
    replace_triggered_by = [random_id.id.hex]
  }
}

resource "null_resource" "create_k8s_cluster" {
  provisioner "local-exec" {
    command     = <<-EOF
      python3 -m venv ${path.module}/project_a-venv
      source ${path.module}/project_a-venv/bin/activate
      pip install -r ${path.module}/kubespray/requirements-2.12.txt
      ansible-playbook -i ${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/inventory.ini -u project_a --become ${path.module}/kubespray/cluster.yml
    
      kconfig=${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/admin.conf
      export KUBECONFIG=~/.kube/config:$kconfig
      kubectl config view --flatten > ~/.kube/newconfig
      mv -u ~/.kube/config ~/.kube/config-backup
      mv -u ~/.kube/newconfig ~/.kube/config
      kcontext=$(grep -oP "(?<=current-context: ).*" $kconfig)
      grep -oP "(?<=certificate-authority-data: ).*" $kconfig > ${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/cluster_ca
      grep -oP "(?<=client-certificate-data: ).*" $kconfig > ${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/client_certificate
      grep -oP "(?<=client-key-data: ).*" $kconfig > ${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/client_key
      kubectl config use-context $kcontext
      kubectl get configmap kube-root-ca.crt -n kube-public -o "jsonpath={.data.ca\.crt}" > ${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/ca_certificate

    EOF
    interpreter = ["/bin/bash", "-c"]
    # when        = create
  }
  lifecycle {
    replace_triggered_by = [random_id.id.hex]
  }
  depends_on = [
    null_resource.check_vms
  ]
}

data "local_sensitive_file" "cluster_ca" {
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/cluster_ca"
  depends_on = [
    null_resource.create_k8s_cluster
  ]
}

data "local_sensitive_file" "client_certificate" {
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/client_certificate"
  depends_on = [
    null_resource.create_k8s_cluster
  ]
}

data "local_sensitive_file" "client_key" {
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/client_key"
  depends_on = [
    null_resource.create_k8s_cluster
  ]
}

data "local_sensitive_file" "ca_certificate" {
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/ca_certificate"
  depends_on = [
    null_resource.create_k8s_cluster
  ]
}

data "local_sensitive_file" "kubeconfig" {
  filename = "${path.module}/kubespray/inventory/${var.kubespray_inventory_name}/artifacts/admin.conf"
  depends_on = [
    null_resource.create_k8s_cluster
  ]
}
