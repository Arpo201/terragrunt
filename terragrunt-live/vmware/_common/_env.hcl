locals {
  ######################################################################################
  # Set custom cluster configuration if cluster already exist (create_cluster = false)
  create_cluster        = false
  custom_cluster_name   = "cluster.local"
  custom_endpoint       = "10.33.50.22"
  custom_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUoa2lHOXcwQ01b45bGRFeE5sb1hEVE15TV4Tmxvd0jkkVHQTFVCQlFBRGdnRVBENDQVFsdfRtVURoN0tLUVORCBUIHZJQ0FUN45tLS0tCg=="
  ######################################################################################
}
