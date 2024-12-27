locals {
  provider_info = {
    cloud_provider = "vmware",
    user           = "sithiparp@site.company.in.th"
    password       = "AB123456"
    server         = "vcenter.site.company.in.th"
  }

  file_path       = split("/terragrunt-live/", get_original_terragrunt_dir())[1]                                    # value example: "dev/vmware/vm"
  state_dir       = "${split("/", "${local.file_path}")[0]}/${split("/", "${local.file_path}")[1]}"                 # value example: "dev/vmware"
  state_file_name = "${replace(split("${local.state_dir}/", "${local.file_path}")[1], "/", "-")}-terraform.tfstate" # value example: "vm-terraform.tfstate"
  state_path      = "${pathexpand("~")}/project_a/tf-state/${local.state_dir}/${local.state_file_name}"             # value example: "/home/arpo/project_a/tf-state/dev/vmware-arpo/k8s-terraform.tfstate"
}

# inputs = {
#   test = run_cmd("echo", "return: ", "${replace(split("${local.state_dir}/", "${local.file_path}")[1], "/", "-")}-terraform.tfstate")
# }

generate "provider" {
  path      = "vmware_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "vsphere" {
      user                 = "${local.provider_info.user}"
      password             = "${local.provider_info.password}"
      vsphere_server       = "${local.provider_info.server}"
      allow_unverified_ssl = true
    }
  EOF
}

remote_state {
  backend = "local"
  config = {
    path = "${local.state_path}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}
