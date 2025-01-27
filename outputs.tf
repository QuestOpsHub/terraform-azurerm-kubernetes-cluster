#--------------
# AKS Versions
#--------------
output "versions" {
  description = "The list of all supported versions."
  value       = data.azurerm_kubernetes_service_versions.current.versions
}

output "latest_version" {
  description = "The most recent version available. If include_preview == false, this is the most recent non-preview version available."
  value       = data.azurerm_kubernetes_service_versions.current.latest_version
}

output "default_version" {
  description = "The N-1 minor non-preview version and latest patch."
  value       = data.azurerm_kubernetes_service_versions.current.default_version
}

#---------------
# AKS Node Pool
#---------------
output "kubernetes_cluster_node_pool" {
  value = azurerm_kubernetes_cluster_node_pool.kubernetes_cluster_node_pool
}

#--------------------------
# Azure Kubernetes Cluster
#--------------------------
output "name" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.name
}

output "id" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.id
}