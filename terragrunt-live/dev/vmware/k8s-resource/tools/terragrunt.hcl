include "root" {
  path = find_in_parent_folders()
}

include "cluster" {
  path = find_in_parent_folders("cluster.hcl")
}

include "k8s_cluster_provider" {
  path = find_in_parent_folders("${dirname(find_in_parent_folders("account.hcl"))}/_common/k8s_cluster_provider.hcl")
}

dependency "datastore" {
  config_path = "../datastore"

  mock_outputs = {
    datastore_a_output             = "fake_datastore_a_output"
    datastore_b_output             = "fake_datastore_b_output"
  }
}

inputs = {
}
