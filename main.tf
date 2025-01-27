#--------------------------
# Azure Kubernetes Cluster
#--------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # default_node_pool block begin
  default_node_pool {
    name                          = var.default_node_pool.name
    vm_size                       = var.default_node_pool.vm_size
    capacity_reservation_group_id = lookup(var.default_node_pool, "capacity_reservation_group_id", null)
    auto_scaling_enabled          = lookup(var.default_node_pool, "auto_scaling_enabled", null)
    host_encryption_enabled       = lookup(var.default_node_pool, "host_encryption_enabled", null)
    node_public_ip_enabled        = lookup(var.default_node_pool, "node_public_ip_enabled", null)
    gpu_instance                  = lookup(var.default_node_pool, "gpu_instance", null)
    host_group_id                 = lookup(var.default_node_pool, "host_group_id", null)
    dynamic "kubelet_config" {
      for_each = lookup(var.default_node_pool, "kubelet_config", {}) != {} ? [var.default_node_pool.kubelet_config] : []
      content {
        allowed_unsafe_sysctls    = lookup(kubelet_config.value, "allowed_unsafe_sysctls", null)
        container_log_max_line    = lookup(kubelet_config.value, "container_log_max_line", null)
        container_log_max_size_mb = lookup(kubelet_config.value, "container_log_max_size_mb", null)
        cpu_cfs_quota_enabled     = lookup(kubelet_config.value, "cpu_cfs_quota_enabled", true)
        cpu_cfs_quota_period      = lookup(kubelet_config.value, "cpu_cfs_quota_period", null)
        cpu_manager_policy        = lookup(kubelet_config.value, "cpu_manager_policy", null)
        image_gc_high_threshold   = lookup(kubelet_config.value, "image_gc_high_threshold", null)
        image_gc_low_threshold    = lookup(kubelet_config.value, "image_gc_low_threshold", null)
        pod_max_pid               = lookup(kubelet_config.value, "pod_max_pid", null)
        topology_manager_policy   = lookup(kubelet_config.value, "topology_manager_policy", null)
      }
    }
    dynamic "linux_os_config" {
      for_each = lookup(var.default_node_pool, "linux_os_config", {}) != {} ? [var.default_node_pool.linux_os_config] : []
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
    fips_enabled      = lookup(var.default_node_pool, "fips_enabled", null)
    kubelet_disk_type = lookup(var.default_node_pool, "kubelet_disk_type", null)
    max_pods          = lookup(var.default_node_pool, "max_pods", null)
    dynamic "node_network_profile" {
      for_each = lookup(var.default_node_pool, "node_network_profile", {}) != {} ? [var.default_node_pool.node_network_profile] : []
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
    node_public_ip_prefix_id     = lookup(var.default_node_pool, "node_public_ip_enabled", null) == true ? lookup(var.default_node_pool, "node_public_ip_prefix_id", null) : null
    node_labels                  = lookup(var.default_node_pool, "node_labels", {})
    only_critical_addons_enabled = lookup(var.default_node_pool, "only_critical_addons_enabled", null)
    orchestrator_version         = data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_size_gb              = lookup(var.default_node_pool, "os_disk_size_gb", null)
    os_disk_type                 = lookup(var.default_node_pool, "os_disk_type", "Managed")
    os_sku                       = lookup(var.default_node_pool, "os_sku", null)
    pod_subnet_id                = lookup(var.default_node_pool, "pod_subnet_id", null)
    proximity_placement_group_id = lookup(var.default_node_pool, "proximity_placement_group_id", null)
    scale_down_mode              = lookup(var.default_node_pool, "scale_down_mode", "Delete")
    snapshot_id                  = lookup(var.default_node_pool, "snapshot_id", null)
    temporary_name_for_rotation  = lookup(var.default_node_pool, "temporary_name_for_rotation", null)
    type                         = lookup(var.default_node_pool, "type", "VirtualMachineScaleSets")
    tags                         = lookup(var.default_node_pool, "tags", {})
    ultra_ssd_enabled            = lookup(var.default_node_pool, "ultra_ssd_enabled", false)
    dynamic "upgrade_settings" {
      for_each = lookup(var.default_node_pool, "upgrade_settings", {}) != {} ? [var.default_node_pool.upgrade_settings] : []
      content {
        drain_timeout_in_minutes      = lookup(upgrade_settings.value, "drain_timeout_in_minutes", 0)
        node_soak_duration_in_minutes = lookup(upgrade_settings.value, "node_soak_duration_in_minutes", 0)
        max_surge                     = upgrade_settings.value.max_surge
      }
    }
    vnet_subnet_id   = lookup(var.default_node_pool, "vnet_subnet_id", null)
    workload_runtime = lookup(var.default_node_pool, "workload_runtime", null)
    zones = (
      lookup(var.default_node_pool, "type", "VirtualMachineScaleSets") == "VirtualMachineScaleSets" &&
      lookup(var.network_profile, "load_balancer_sku", "standard") == "standard"
    ) ? lookup(var.default_node_pool, "zones", null) : null
    max_count = lookup(var.default_node_pool, "auto_scaling_enabled", null) == true ? lookup(var.default_node_pool, "max_count", null) : null
    min_count = lookup(var.default_node_pool, "auto_scaling_enabled", null) == true ? lookup(var.default_node_pool, "min_count", null) : null
  }
  # default_node_pool block end

  dns_prefix                 = var.dns_prefix_private_cluster == null ? replace(var.name, "-", "") : null
  dns_prefix_private_cluster = var.name == null ? var.dns_prefix_private_cluster : null

  dynamic "aci_connector_linux" {
    for_each = try(var.aci_connector_linux, {}) != {} ? [var.aci_connector_linux] : []
    content {
      subnet_name = aci_connector_linux.value.subnet_name
    }
  }

  automatic_upgrade_channel = try(var.automatic_upgrade_channel, null)

  dynamic "api_server_access_profile" {
    for_each = try(var.api_server_access_profile, {}) != {} ? [var.api_server_access_profile] : []
    content {
      authorized_ip_ranges = lookup(api_server_access_profile.value, "authorized_ip_ranges", null)
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = try(var.auto_scaler_profile, {}) != {} ? [var.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = lookup(auto_scaler_profile.value, "balance_similar_node_groups", false)
      expander                         = lookup(auto_scaler_profile.value, "expander", "random")
      max_graceful_termination_sec     = lookup(auto_scaler_profile.value, "max_graceful_termination_sec", 600)
      max_node_provisioning_time       = lookup(auto_scaler_profile.value, "max_node_provisioning_time", "15m")
      max_unready_nodes                = lookup(auto_scaler_profile.value, "max_unready_nodes", 3)
      max_unready_percentage           = lookup(auto_scaler_profile.value, "max_unready_percentage", 45)
      new_pod_scale_up_delay           = lookup(auto_scaler_profile.value, "new_pod_scale_up_delay", "10s")
      scale_down_delay_after_add       = lookup(auto_scaler_profile.value, "scale_down_delay_after_add", "10m")
      scale_down_delay_after_delete    = lookup(auto_scaler_profile.value, "scale_down_delay_after_delete", "scan_interval")
      scale_down_delay_after_failure   = lookup(auto_scaler_profile.value, "scale_down_delay_after_failure", "3m")
      scan_interval                    = lookup(auto_scaler_profile.value, "scan_interval", "10s")
      scale_down_unneeded              = lookup(auto_scaler_profile.value, "scale_down_unneeded", "10m")
      scale_down_unready               = lookup(auto_scaler_profile.value, "scale_down_unready", "20m")
      scale_down_utilization_threshold = lookup(auto_scaler_profile.value, "scale_down_utilization_threshold", 0.5)
      empty_bulk_delete_max            = lookup(auto_scaler_profile.value, "empty_bulk_delete_max", 10)
      skip_nodes_with_local_storage    = lookup(auto_scaler_profile.value, "skip_nodes_with_local_storage", true)
      skip_nodes_with_system_pods      = lookup(auto_scaler_profile.value, "skip_nodes_with_system_pods", true)
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = try(var.azure_active_directory_role_based_access_control, {}) != {} ? [var.azure_active_directory_role_based_access_control] : []
    content {
      tenant_id              = data.azurerm_client_config.current.tenant_id
      admin_group_object_ids = lookup(azure_active_directory_role_based_access_control.value, "admin_group_object_ids", [])
      azure_rbac_enabled     = lookup(azure_active_directory_role_based_access_control.value, "azure_rbac_enabled", null)
    }
  }

  azure_policy_enabled = try(var.azure_policy_enabled, null)

  dynamic "confidential_computing" {
    for_each = try(var.confidential_computing, {}) != {} ? [var.confidential_computing] : []
    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }

  cost_analysis_enabled            = (var.sku_tier == "Standard" || var.sku_tier == "Premium") ? try(var.cost_analysis_enabled, false) : false
  disk_encryption_set_id           = try(var.disk_encryption_set_id, null)
  edge_zone                        = try(var.edge_zone, null)
  http_application_routing_enabled = try(var.http_application_routing_enabled, null)

  dynamic "http_proxy_config" {
    for_each = try(var.http_proxy_config, {}) != {} ? [var.http_proxy_config] : []
    content {
      http_proxy  = lookup(http_proxy_config.value, "http_proxy", null)
      https_proxy = lookup(http_proxy_config.value, "https_proxy", null)
      no_proxy    = lookup(http_proxy_config.value, "no_proxy", [])
      trusted_ca  = lookup(http_proxy_config.value, "trusted_ca", null)
    }
  }

  dynamic "identity" {
    for_each = try(var.service_principal, {}) == {} && try(var.identity.type, null) != null ? [var.identity.type] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.type == "UserAssigned" || var.identity.type == "SystemAssigned, UserAssigned" ? var.identity.identity_ids : null
    }
  }

  image_cleaner_enabled        = try(var.image_cleaner_enabled, null)
  image_cleaner_interval_hours = try(var.image_cleaner_interval_hours, 48)

  dynamic "ingress_application_gateway" {
    for_each = try(var.ingress_application_gateway, {}) != {} ? [var.ingress_application_gateway] : []
    content {
      gateway_id   = lookup(var.ingress_application_gateway, "gateway_id", null)
      gateway_name = lookup(var.ingress_application_gateway, "gateway_name", null)
      subnet_cidr  = lookup(var.ingress_application_gateway, "subnet_cidr", null)
      subnet_id    = lookup(var.ingress_application_gateway, "gateway_id", null) == null ? lookup(var.ingress_application_gateway, "subnet_id", null) : null
    }
  }

  dynamic "key_management_service" {
    for_each = try(var.key_management_service, {}) != {} ? [var.key_management_service] : []
    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = lookup(key_management_service.value, "key_vault_network_access", "Public")
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = (
      lookup(var.key_vault_secrets_provider, "secret_rotation_enabled", null) != null || lookup(var.key_vault_secrets_provider, "secret_rotation_interval", null) != null
    ) ? [var.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = lookup(key_vault_secrets_provider.value, "secret_rotation_enabled", null)
      secret_rotation_interval = lookup(key_vault_secrets_provider.value, "secret_rotation_enabled", null) == true ? lookup(key_vault_secrets_provider.value, "secret_rotation_interval", "2m") : null
    }
  }

  dynamic "kubelet_identity" {
    for_each = try(var.kubelet_identity, {}) != {} ? [var.kubelet_identity] : []
    content {
      client_id                 = lookup(kubelet_identity.value, "client_id", null)
      object_id                 = lookup(kubelet_identity.value, "object_id", null)
      user_assigned_identity_id = lookup(kubelet_identity.value, "user_assigned_identity_id", null)
    }
  }

  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  dynamic "linux_profile" {
    for_each = try(var.linux_profile, {}) != {} ? [var.linux_profile] : []
    content {
      admin_username = linux_profile.value.adminuser
      ssh_key {
        key_data = linux_profile.value.public_key
      }
    }
  }

  local_account_disabled = try(var.local_account_disabled, null)

  dynamic "maintenance_window" {
    for_each = try(var.maintenance_window, {}) != {} ? [var.maintenance_window] : []
    content {
      dynamic "allowed" {
        for_each = length(keys(lookup(maintenance_window.value, "allowed", {}))) > 0 ? lookup(maintenance_window.value, "allowed", {}) : {}
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = length(keys(lookup(maintenance_window.value, "not_allowed", {}))) > 0 ? lookup(maintenance_window.value, "not_allowed", {}) : {}
        content {
          end   = allowed.value.end
          start = allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = try(var.maintenance_window_auto_upgrade, {}) != {} ? [var.maintenance_window_auto_upgrade] : []
    content {
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      duration     = maintenance_window_auto_upgrade.value.duration
      day_of_week  = lookup(maintenance_window_auto_upgrade.value, "day_of_week", null)
      day_of_month = lookup(maintenance_window_auto_upgrade.value, "day_of_month", null)
      week_index   = lookup(maintenance_window_auto_upgrade.value, "week_index", null)
      start_time   = lookup(maintenance_window_auto_upgrade.value, "start_time", null)
      utc_offset   = lookup(maintenance_window_auto_upgrade.value, "utc_offset", null)
      start_date   = lookup(maintenance_window_auto_upgrade.value, "start_date", null)
      dynamic "not_allowed" {
        for_each = length(keys(lookup(maintenance_window_auto_upgrade.value, "not_allowed", {}))) > 0 ? lookup(maintenance_window_auto_upgrade.value, "not_allowed", {}) : {}
        content {
          end   = allowed.value.end
          start = allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = try(var.maintenance_window_node_os, {}) != {} ? [var.maintenance_window_node_os] : []
    content {
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      duration     = maintenance_window_node_os.value.duration
      day_of_week  = lookup(maintenance_window_node_os.value, "day_of_week", null)
      day_of_month = lookup(maintenance_window_node_os.value, "day_of_month", null)
      week_index   = lookup(maintenance_window_node_os.value, "week_index", null)
      start_time   = lookup(maintenance_window_node_os.value, "start_time", null)
      utc_offset   = lookup(maintenance_window_node_os.value, "utc_offset", null)
      start_date   = lookup(maintenance_window_node_os.value, "start_date", null)
      dynamic "not_allowed" {
        for_each = length(keys(lookup(maintenance_window_node_os.value, "not_allowed", {}))) > 0 ? lookup(maintenance_window_node_os.value, "not_allowed", {}) : {}
        content {
          end   = allowed.value.end
          start = allowed.value.start
        }
      }
    }
  }

  dynamic "microsoft_defender" {
    for_each = try(var.microsoft_defender, {}) != {} ? [var.microsoft_defender] : []
    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  dynamic "monitor_metrics" {
    for_each = try(var.monitor_metrics, {}) != {} ? [var.monitor_metrics] : []
    content {
      annotations_allowed = lookup(monitor_metrics.value, "annotations_allowed", null)
      labels_allowed      = lookup(monitor_metrics.value, "labels_allowed", null)
    }
  }

  dynamic "network_profile" {
    for_each = try(var.network_profile, {}) != {} ? [var.network_profile] : []
    content {
      network_plugin      = network_profile.value.network_plugin
      network_mode        = lookup(network_profile.value, "network_mode", null)
      network_policy      = lookup(network_profile.value, "network_policy", null)
      dns_service_ip      = lookup(network_profile.value, "dns_service_ip", null)
      network_data_plane  = lookup(network_profile.value, "network_data_plane", "azure")
      network_plugin_mode = lookup(network_profile.value, "network_plugin_mode", null)
      outbound_type       = lookup(network_profile.value, "outbound_type", "loadBalancer")
      pod_cidr            = lookup(network_profile.value, "pod_cidr", null)
      pod_cidrs           = lookup(network_profile.value, "pod_cidrs", [])
      service_cidr        = lookup(network_profile.value, "service_cidr", null)
      service_cidrs       = lookup(network_profile.value, "service_cidrs", null)
      ip_versions         = lookup(network_profile.value, "ip_versions", [])
      load_balancer_sku   = lookup(network_profile.value, "load_balancer_sku", "standard")
      dynamic "load_balancer_profile" {
        for_each = lookup(network_profile.value, "load_balancer_sku", "standard") == "standard" && lookup(network_profile.value, "load_balancer_profile", {}) != {} ? [network_profile.value.load_balancer_profile] : []
        content {
          idle_timeout_in_minutes     = lookup(load_balancer_profile.value, "idle_timeout_in_minutes", 30)
          managed_outbound_ip_count   = lookup(load_balancer_profile.value, "managed_outbound_ip_count", null)
          managed_outbound_ipv6_count = lookup(load_balancer_profile.value, "managed_outbound_ipv6_count", null)
          outbound_ip_address_ids     = lookup(load_balancer_profile.value, "outbound_ip_address_ids", null)
          outbound_ip_prefix_ids      = lookup(load_balancer_profile.value, "outbound_ip_prefix_ids", null)
          outbound_ports_allocated    = lookup(load_balancer_profile.value, "outbound_ports_allocated", 0)
        }
      }
      dynamic "nat_gateway_profile" {
        for_each = (
          lookup(network_profile.value, "load_balancer_sku", "standard") == "standard" &&
          (
            lookup(network_profile.value, "outbound_type", "loadBalancer") == "managedNATGateway" ||
            lookup(network_profile.value, "outbound_type", "loadBalancer") == "userAssignedNATGateway"
          ) &&
          length(keys(lookup(network_profile.value, "nat_gateway_profile", {}))) > 0
        ) ? [network_profile.value.nat_gateway_profile] : []
        content {
          idle_timeout_in_minutes   = lookup(nat_gateway_profile.value, "idle_timeout_in_minutes", 4)
          managed_outbound_ip_count = lookup(nat_gateway_profile.value, "managed_outbound_ip_count", null)
        }
      }
    }
  }

  node_os_upgrade_channel = try(var.node_os_upgrade_channel, "NodeImage")
  node_resource_group     = try(var.node_resource_group, null)
  oidc_issuer_enabled     = try(var.oidc_issuer_enabled, null)

  dynamic "oms_agent" {
    for_each = try(var.oms_agent, {}) != {} ? [var.oms_agent] : []
    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = lookup(oms_agent.value, "msi_auth_for_monitoring_enabled", null)
    }
  }

  open_service_mesh_enabled           = try(var.open_service_mesh_enabled, null)
  private_cluster_enabled             = try(var.private_cluster_enabled, false)
  private_dns_zone_id                 = try(var.private_dns_zone_id, null)
  private_cluster_public_fqdn_enabled = try(var.private_cluster_public_fqdn_enabled, false)

  dynamic "service_mesh_profile" {
    for_each = try(var.service_mesh_profile, {}) != {} ? [var.service_mesh_profile] : []
    content {
      mode                             = service_mesh_profile.value.mode
      revisions                        = service_mesh_profile.value.revisions
      internal_ingress_gateway_enabled = lookup(service_mesh_profile.value, "internal_ingress_gateway_enabled", null)
      external_ingress_gateway_enabled = lookup(service_mesh_profile.value, "external_ingress_gateway_enabled", null)
      dynamic "certificate_authority" {
        for_each = lookup(service_mesh_profile.value, "certificate_authority", {}) != {} ? [service_mesh_profile.value.certificate_authority] : []
        content {
          key_vault_id           = certificate_authority.value.key_vault_id
          root_cert_object_name  = certificate_authority.value.root_cert_object_name
          cert_chain_object_name = certificate_authority.value.cert_chain_object_name
          cert_object_name       = certificate_authority.value.cert_object_name
          key_object_name        = certificate_authority.value.key_object_name
        }
      }
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = try(var.workload_autoscaler_profile, {}) != {} ? [var.workload_autoscaler_profile] : []
    content {
      keda_enabled                    = lookup(workload_autoscaler_profile.value, "keda_enabled", null)
      vertical_pod_autoscaler_enabled = lookup(workload_autoscaler_profile.value, "vertical_pod_autoscaler_enabled", null)
    }
  }

  workload_identity_enabled         = try(var.workload_identity_enabled, false)
  role_based_access_control_enabled = try(var.role_based_access_control_enabled, true)
  run_command_enabled               = try(var.run_command_enabled, true)

  dynamic "service_principal" {
    for_each = try(var.identity.type, {}) == {} && try(var.service_principal, {}) != {} ? [var.service_principal] : []
    content {
      client_id     = service_principal.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  sku_tier = try(var.sku_tier, "Free")

  dynamic "storage_profile" {
    for_each = try(var.storage_profile, {}) != {} ? [var.storage_profile] : []
    content {
      blob_driver_enabled         = lookup(storage_profile.value, "blob_driver_enabled", false)
      disk_driver_enabled         = lookup(storage_profile.value, "disk_driver_enabled", true)
      file_driver_enabled         = lookup(storage_profile.value, "file_driver_enabled", true)
      snapshot_controller_enabled = lookup(storage_profile.value, "snapshot_controller_enabled", true)
    }
  }

  support_plan = try(var.support_plan, "KubernetesOfficial")

  dynamic "web_app_routing" {
    for_each = try(var.web_app_routing, {}) != {} ? [var.web_app_routing] : []
    content {
      dns_zone_ids = web_app_routing.value.dns_zone_ids
    }
  }

  dynamic "windows_profile" {
    for_each = try(var.windows_profile, {}) != {} ? [var.windows_profile] : []
    content {
      admin_username = windows_profile.value.admin_username
      admin_password = lookup(windows_profile.value, "admin_password", null)
      license        = lookup(windows_profile.value, "license", null)
      dynamic "gmsa" {
        for_each = lookup(windows_profile.value, "gmsa", {}) != {} ? [windows_profile.value.gmsa] : []
        content {
          dns_server  = gmsa.value.dns_server
          root_domain = gmsa.value.root_domain
        }
      }
    }
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["creation_timestamp"],
    ]
  }
}