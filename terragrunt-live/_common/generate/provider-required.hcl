generate "aws" {
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
aws = {
  source = "hashicorp/aws"
  version = "PROVIDER_VERSION"
}
EOF
}

generate "gcp" {
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
google = {
  source = "hashicorp/google"
  version = "PROVIDER_VERSION"
}
EOF

generate "kubectl" {
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
kubectl = {
  source = "alekc/kubectl"
  version = "PROVIDER_VERSION"
}
EOF
}

generate "k8s" {
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
kubernetes = {
  source  = "hashicorp/kubernetes"
  version = "PROVIDER_VERSION"
}
EOF
}

generate "helm" {
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
helm = {
  source  = "hashicorp/helm"
  version = "PROVIDER_VERSION"
}
EOF
}
