# Terragrunt 

This project uses [Terragrunt](https://terragrunt.gruntwork.io/) to manage the infrastructure when have multi-environments.

Terraform v1.3.2, Terragrunt v0.38.12

## Prerequisites

- [Terraform](https://www.terraform.io/)
- [Terragrunt](https://terragrunt.gruntwork.io/)


## Directory structure

- `terragrunt-live/<environment>`: Contains the `Terragrunt` configs.
- `terragrunt-module/<environment>`: Contains the environment-specific `Terragrunt` configs and Terraform modules for that environment (gcp, vmware).

## Configuration

All configuration for this project is stored in the `.hcl` files in each environment directory. Modify these files to suit your needs.

## Common commands
Terragrunt have same commands as terraform

```bash
# terragrunt/terragrunt-live
terragrunt run-all apply --terragrunt-working-dir ./dev/gcp

# terragrunt/terragrunt-live/dev/gcp
terragrunt run-all destroy --terragrunt-ignore-dependency-errors


terragrunt plan
terragrunt apply
terragrunt destroy
terragrunt output -json

```


## Structure example for real project

### Terragrunt-live tree

```bash
arpo@ubuntu:~/PROJECT/terragrunt-live$ tree
.
├── dev
│   ├── env.hcl
│   ├── gcp
│   │   ├── account.hcl
│   │   ├── _common
│   │   │   ├── _env.hcl
│   │   │   ├── k8s_cluster_provider.hcl
│   │   │   ├── kubernetes_provider.hcl
│   │   │   └── network_dependency.hcl
│   │   ├── credential.json
│   │   ├── k8s
│   │   │   └── terragrunt.hcl
│   │   ├── k8s-resource
│   │   │   ├── cluster.hcl
│   │   │   ├── config
│   │   │   │   └── terragrunt.hcl
│   │   │   ├── core
│   │   │   │   └── terragrunt.hcl
│   │   │   ├── datastore
│   │   │   │   └── terragrunt.hcl
│   │   │   ├── devops-tools
│   │   │   │   └── terragrunt.hcl
│   │   │   └── monitoring
│   │   │       └── terragrunt.hcl
│   │   └── network
│   │       └── terragrunt.hcl
│   └── vmware
│       ├── account.hcl
│       ├── _common
│       │   ├── _env.hcl
│       │   ├── k8s_cluster_provider.hcl
│       │   ├── kubernetes_provider.hcl
│       │   └── vm_dependency.hcl
│       ├── k8s
│       │   └── terragrunt.hcl
│       ├── k8s-resource
│       │   ├── cluster.hcl
│       │   ├── config
│       │   │   └── terragrunt.hcl
│       │   ├── core
│       │   │   └── terragrunt.hcl
│       │   ├── datastore
│       │   │   └── terragrunt.hcl
│       │   ├── devops-tools
│       │   │   └── terragrunt.hcl
│       │   └── monitoring
│       │       └── terragrunt.hcl
│       └── vm
│           └── terragrunt.hcl
├── prd
│   └── README.md
└── terragrunt.hcl
```

### Terragrunt-modules tree
```bash
arpo@ubuntu:~/PROJECT/terragrunt-modules$ tree -L 4
.
├── gcp
│   ├── k8s
│   │   ├── google-gke.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── network
│       ├── google-firewall.tf
│       ├── google-router.tf
│       ├── google-vpc.tf
│       ├── outputs.tf
│       └── variables.tf
├── k8s-resource
│   ├── config
│   │   ├── config.tf
│   │   ├── module
│   │   │   ├── harbor
│   │   │   └── keycloak
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── sonarqube.tf
│   │   ├── values
│   │   │   └── sonarqube-values.yaml
│   │   └── variables.tf
│   ├── core
│   │   ├── certificate.tf
│   │   ├── cloudflare.tf
│   │   ├── ingress-nginx.tf
│   │   ├── kubed.tf
│   │   ├── metrics-server.tf
│   │   ├── namespace.tf
│   │   ├── nfs-client.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── values
│   │   │   └── metrics-server-values.yaml
│   │   └── variables.tf
│   ├── datastore
│   │   ├── minio.tf
│   │   ├── namespace.tf
│   │   ├── outputs.tf
│   │   ├── postgresql.tf
│   │   ├── provider.tf
│   │   ├── rabbitmq.tf
│   │   ├── random_password.tf
│   │   ├── redis.tf
│   │   ├── values
│   │   │   ├── minio-values.yaml
│   │   │   ├── postgresql-values.yaml
│   │   │   ├── rabbitmq-values.yaml
│   │   │   └── redis-values.yaml
│   │   └── variables.tf
│   ├── devops-tools
│   │   ├── harbor.tf
│   │   ├── keycloak.tf
│   │   ├── keycloak_theme.tf
│   │   ├── namespace.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── random_password.tf
│   │   ├── sonarqube_password.tf
│   │   ├── values
│   │   │   ├── harbor-values.yaml
│   │   │   └── keycloak-values.yaml
│   │   └── variables.tf
│   └── monitoring
│       ├── fluentbit.tf
│       ├── grafana.tf
│       ├── namespace.tf
│       ├── opensearch-dashboard.tf
│       ├── opensearch.tf
│       ├── opensearch_tls.tf
│       ├── outputs.tf
│       ├── prometheus-exporter.tf
│       ├── prometheus.tf
│       ├── provider.tf
│       ├── random_password.tf
│       ├── values
│       │   ├── fluentbit-values.yaml
│       │   ├── grafana-values.yaml
│       │   ├── opensearch-dashboard-values.yaml
│       │   ├── opensearch-values.yaml
│       │   ├── prometheus-blackbox-exporter-values.yaml
│       │   ├── prometheus-elasticsearch-exporter-values.yaml
│       │   ├── prometheus-postgresql-exporter-values.yaml
│       │   ├── prometheus-rabbitmq-exporter-values.yaml
│       │   ├── prometheus-redis-exporter-values.yaml
│       │   └── prometheus-values.yaml
│       └── variables.tf
└── vmware
    ├── k8s
    │   ├── create-cluster.tf
    │   ├── kubespray
    │   ├── outputs.tf
    │   ├── script.sh
    │   ├── templates
    │   │   ├── helm-values-nfs.yml.tftpl
    │   │   ├── kubespray-all.yml.tftpl
    │   │   ├── kubespray-inventory.ini.tftpl
    │   │   └── kubespray-k8s-cluster.yml.tftpl
    │   └── variables.tf
    └── vm
        ├── data-sources.tf
        ├── output.tf
        ├── provider.tf
        ├── templates
        │   ├── user-data-fedoraCoreOS-node.fcc
        │   ├── user-data-ubuntu-master-lb.yaml
        │   ├── user-data-ubuntu-storage.yaml
        │   └── user-data-ubuntu-worker-lb.yaml
        ├── variables.tf
        ├── vm_config.tf
        └── vm_generate.tf
```