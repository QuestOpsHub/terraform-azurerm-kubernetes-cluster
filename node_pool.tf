#---------------
# AKS Node Pool
#---------------
resource "azurerm_kubernetes_cluster_node_pool" "kubernetes_cluster_node_pool" {
  for_each                      = var.kubernetes_cluster_node_pool
  name                          = each.key
  kubernetes_cluster_id         = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size                       = each.value.vm_size
  capacity_reservation_group_id = lookup(each.value, "capacity_reservation_group_id", null)
  auto_scaling_enabled          = lookup(each.value, "auto_scaling_enabled", true)
  host_encryption_enabled       = lookup(each.value, "host_encryption_enabled", null)
  node_public_ip_enabled        = lookup(each.value, "node_public_ip_enabled", null)
  eviction_policy               = lookup(each.value, "priority", null) == "Spot" ? lookup(each.value, "eviction_policy", null) : null
  host_group_id                 = lookup(each.value, "host_group_id", null)

  dynamic "kubelet_config" {
    for_each = lookup(each.value, "kubelet_config", {}) != {} ? [each.value.kubelet_config] : []
    content {
      allowed_unsafe_sysctls    = lookup(kubelet_config.value, "allowed_unsafe_sysctls", null)
      container_log_max_line    = lookup(kubelet_config.value, "container_log_max_line", null)
      container_log_max_size_mb = lookup(kubelet_config.value, "container_log_max_size_mb", null)
      cpu_cfs_quota_enabled     = lookup(kubelet_config.value, "cpu_cfs_quota_enabled", null)
      cpu_cfs_quota_period      = lookup(kubelet_config.value, "cpu_cfs_quota_period", null)
      cpu_manager_policy        = lookup(kubelet_config.value, "cpu_manager_policy", null)
      image_gc_high_threshold   = lookup(kubelet_config.value, "image_gc_high_threshold", null)
      image_gc_low_threshold    = lookup(kubelet_config.value, "image_gc_low_threshold", null)
      pod_max_pid               = lookup(kubelet_config.value, "pod_max_pid", null)
      topology_manager_policy   = lookup(kubelet_config.value, "topology_manager_policy", null)
    }
  }

  dynamic "linux_os_config" {
    for_each = lookup(each.value, "linux_os_config", {}) != {} ? [each.value.linux_os_config] : []
    content {
      swap_file_size_mb = lookup(linux_os_config.value, "swap_file_size_mb", null)
      dynamic "sysctl_config" {
        for_each = lookup(linux_os_config.value, "sysctl_config", {}) != {} ? [linux_os_config.value.sysctl_config] : []
        content {
          fs_aio_max_nr                      = lookup(sysctl_config.value, "fs_aio_max_nr", null)
          fs_file_max                        = lookup(sysctl_config.value, "fs_file_max", null)
          fs_inotify_max_user_watches        = lookup(sysctl_config.value, "fs_inotify_max_user_watches", null)
          fs_nr_open                         = lookup(sysctl_config.value, "fs_nr_open", null)
          kernel_threads_max                 = lookup(sysctl_config.value, "kernel_threads_max", null)
          net_core_netdev_max_backlog        = lookup(sysctl_config.value, "net_core_netdev_max_backlog", null)
          net_core_optmem_max                = lookup(sysctl_config.value, "net_core_optmem_max", null)
          net_core_rmem_default              = lookup(sysctl_config.value, "net_core_rmem_default", null)
          net_core_rmem_max                  = lookup(sysctl_config.value, "net_core_rmem_max", null)
          net_core_somaxconn                 = lookup(sysctl_config.value, "net_core_somaxconn", null)
          net_core_wmem_default              = lookup(sysctl_config.value, "net_core_wmem_default", null)
          net_core_wmem_max                  = lookup(sysctl_config.value, "net_core_wmem_max", null)
          net_ipv4_ip_local_port_range_max   = lookup(sysctl_config.value, "net_ipv4_ip_local_port_range_max", null)
          net_ipv4_ip_local_port_range_min   = lookup(sysctl_config.value, "net_ipv4_ip_local_port_range_min", null)
          net_ipv4_neigh_default_gc_thresh1  = lookup(sysctl_config.value, "net_ipv4_neigh_default_gc_thresh1", null)
          net_ipv4_neigh_default_gc_thresh2  = lookup(sysctl_config.value, "net_ipv4_neigh_default_gc_thresh2", null)
          net_ipv4_neigh_default_gc_thresh3  = lookup(sysctl_config.value, "net_ipv4_neigh_default_gc_thresh3", null)
          net_ipv4_tcp_fin_timeout           = lookup(sysctl_config.value, "net_ipv4_tcp_fin_timeout", null)
          net_ipv4_tcp_keepalive_intvl       = lookup(sysctl_config.value, "net_ipv4_tcp_keepalive_intvl", null)
          net_ipv4_tcp_keepalive_probes      = lookup(sysctl_config.value, "net_ipv4_tcp_keepalive_probes", null)
          net_ipv4_tcp_keepalive_time        = lookup(sysctl_config.value, "net_ipv4_tcp_keepalive_time", null)
          net_ipv4_tcp_max_syn_backlog       = lookup(sysctl_config.value, "net_ipv4_tcp_max_syn_backlog", null)
          net_ipv4_tcp_max_tw_buckets        = lookup(sysctl_config.value, "net_ipv4_tcp_max_tw_buckets", null)
          net_ipv4_tcp_tw_reuse              = lookup(sysctl_config.value, "net_ipv4_tcp_tw_reuse", null)
          net_netfilter_nf_conntrack_buckets = lookup(sysctl_config.value, "net_netfilter_nf_conntrack_buckets", null)
          net_netfilter_nf_conntrack_max     = lookup(sysctl_config.value, "net_netfilter_nf_conntrack_max", null)
          vm_max_map_count                   = lookup(sysctl_config.value, "vm_max_map_count", null)
          vm_swappiness                      = lookup(sysctl_config.value, "vm_swappiness", null)
          vm_vfs_cache_pressure              = lookup(sysctl_config.value, "vm_vfs_cache_pressure", null)
        }
      }
      transparent_huge_page_defrag  = lookup(linux_os_config.value, "transparent_huge_page_defrag", null)
      transparent_huge_page_enabled = lookup(linux_os_config.value, "transparent_huge_page_enabled", null)
    }
  }

  fips_enabled      = lookup(each.value, "fips_enabled", null)
  gpu_instance      = lookup(each.value, "gpu_instance", null)
  kubelet_disk_type = lookup(each.value, "kubelet_disk_type", null)
  max_pods          = azurerm_kubernetes_cluster.kubernetes_cluster.default_node_pool[0].max_pods
  mode              = lookup(each.value, "fips_enabled", "User")

  dynamic "node_network_profile" {
    for_each = lookup(each.value, "node_network_profile", {}) != {} ? [each.value.node_network_profile] : []
    content {
      dynamic "allowed_host_ports" {
        for_each = length(keys(lookup(node_network_profile.value, "allowed_host_ports", {}))) > 0 ? lookup(node_network_profile.value, "allowed_host_ports", {}) : {}
        content {
          port_start = lookup(allowed_host_ports.value, "port_start", null)
          port_end   = lookup(allowed_host_ports.value, "port_end", null)
          protocol   = lookup(allowed_host_ports.value, "protocol", null)
        }
      }
      application_security_group_ids = lookup(node_network_profile.value, "application_security_group_ids", null)
      node_public_ip_tags            = lookup(node_network_profile.value, "node_public_ip_tags", null)
    }
  }

  node_labels                  = lookup(each.value, "node_labels", null)
  node_public_ip_prefix_id     = lookup(each.value, "node_public_ip_enabled", null) == true ? lookup(each.value, "node_public_ip_prefix_id", null) : null
  node_taints                  = lookup(each.value, "node_taints", [])
  orchestrator_version         = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb              = lookup(each.value, "os_disk_size_gb", null)
  os_disk_type                 = lookup(each.value, "os_disk_size_gb", "Managed")
  pod_subnet_id                = lookup(each.value, "pod_subnet_id", null)
  os_sku                       = lookup(each.value, "os_sku", null)
  os_type                      = lookup(each.value, "os_type", null)
  priority                     = lookup(each.value, "priority", null)
  proximity_placement_group_id = lookup(each.value, "proximity_placement_group_id", null)
  spot_max_price               = lookup(each.value, "priority", null) == "Spot" ? lookup(each.value, "spot_max_price", null) : null
  snapshot_id                  = lookup(each.value, "snapshot_id", null)
  scale_down_mode              = lookup(each.value, "scale_down_mode", "Delete")
  ultra_ssd_enabled            = lookup(each.value, "ultra_ssd_enabled", false)

  upgrade_settings {
    drain_timeout_in_minutes      = azurerm_kubernetes_cluster.kubernetes_cluster.default_node_pool[0].upgrade_settings[0].drain_timeout_in_minutes
    node_soak_duration_in_minutes = azurerm_kubernetes_cluster.kubernetes_cluster.default_node_pool[0].upgrade_settings[0].node_soak_duration_in_minutes
    max_surge                     = azurerm_kubernetes_cluster.kubernetes_cluster.default_node_pool[0].upgrade_settings[0].max_surge
  }

  vnet_subnet_id = lookup(each.value, "vnet_subnet_id", var.nodepool_subnet_id)

  dynamic "windows_profile" {
    for_each = lookup(each.value, "windows_profile", {}) != {} ? [each.value.windows_profile] : []
    content {
      outbound_nat_enabled = lookup(windows_profile.value, "outbound_nat_enabled", true)
    }
  }

  workload_runtime = lookup(each.value, "workload_runtime", null)
  zones            = azurerm_kubernetes_cluster.kubernetes_cluster.default_node_pool[0].zones
  max_count        = lookup(each.value, "auto_scaling_enabled", true) == true ? lookup(each.value, "max_count", null) : null
  min_count        = lookup(each.value, "auto_scaling_enabled", true) == true ? lookup(each.value, "min_count", null) : null
  node_count       = lookup(each.value, "node_count", null)

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["creation_timestamp"],
    ]
  }
}