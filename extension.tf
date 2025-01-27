#---------------
# AKS Extension
#---------------
# @todo update this resource
resource "azurerm_kubernetes_cluster_extension" "aks_extension" {
  for_each                         = var.aks_extension
  name                             = each.key
  cluster_id                       = azurerm_kubernetes_cluster.kubernetes_cluster.id
  extension_type                   = each.value.type
  release_train                    = lookup(each.value, "release_train", null)
  release_namespace                = lookup(each.value, "release_namespace", null)
  configuration_protected_settings = lookup(each.value, "configuration_protected_settings", null)
  configuration_settings           = lookup(each.value, "configuration_settings", null)
  target_namespace                 = lookup(each.value, "target_namespace", null)
  version                          = lookup(each.value, "version", null)
}