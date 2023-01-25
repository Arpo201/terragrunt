output "cluster_name" {
  value = var.cluster_name
}

output "endpoint" {
  value = var.master_lb.ip[0]
  sensitive = true
}

output "ca_certificate" {
  value     = data.local_sensitive_file.ca_certificate.content_base64
  sensitive = true
}

output "kubeconfig" {
  value     = data.local_sensitive_file.kubeconfig.content
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = replace(data.local_sensitive_file.cluster_ca.content, "\n", "")
  sensitive = true
}

output "client_certificate" {
  value     = replace(data.local_sensitive_file.client_certificate.content, "\n", "")
  sensitive = true
}

output "client_key" {
  value     = replace(data.local_sensitive_file.client_key.content, "\n", "")
  sensitive = true
}