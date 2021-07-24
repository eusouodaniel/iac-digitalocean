provider "digitalocean" {
    token = var.digital_ocean_token
}

#docker
resource "digitalocean_container_registry" "container-registry" {
    name                   = var.digital_ocean_registry_name
    subscription_tier_slug = var.digital_ocean_subscription
}

data "digitalocean_container_registry" "container-registry" {
    name = digitalocean_container_registry.container-registry.name
}

resource "digitalocean_container_registry_docker_credentials" "docker-credentials" {
    write = true
    registry_name = digitalocean_container_registry.container-registry.name
}

output "docker-container-registry" {
  value = digitalocean_container_registry.container-registry.endpoint
}

#k8s
resource "digitalocean_kubernetes_cluster" "cluster" {
    name = var.digital_ocean_cluster_name
    region = var.digital_ocean_cluster_region
    version = var.digital_ocean_cluster_version
    node_pool {
        name = var.digital_ocean_cluster_pool_name
        size = var.digital_ocean_cluster_pool_size
        auto_scale = true
        node_count = 1
        min_nodes = 1
        max_nodes = 2
    }
}

output "cluster-config" {
  value = digitalocean_kubernetes_cluster.cluster.kube_config[0]["raw_config"]
  sensitive = true
}

output "ip" {
    value = digitalocean_kubernetes_cluster.cluster.ipv4_address
}