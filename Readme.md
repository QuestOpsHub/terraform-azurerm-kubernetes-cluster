# Azure Kubernetes Cluster Terraform Module

Terraform module to create a Managed Kubernetes Cluster.

# Table of Contents

- [Azure Resource Naming Convention](#azure-resource-naming-convention)
    - [Format](#Format)
    - [Components](#Components)
- [AKS SSH Keys](#aks-ssh-keys)
- [ACI Connector for AKS](#aci-connector-for-aks)
- [Ingress Application Gateway](#ingress-application-gateway)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Azure Resource Naming Convention

Resource names should clearly indicate their type, workload, environment, and region. Using a consistent naming convention ensures clarity, uniformity, and easy identification across all repositories.

#### Format

```
<resource_prefix>-<app_or_project>-<environment>-<region>-<optional_unique_suffix>
```

#### Components

| **Component**           | **Description**                                                                      | **Example**             |
|--------------------------|--------------------------------------------------------------------------------------|-------------------------|
| `resource_prefix`        | Short abbreviation for the resource type.                                           | `rg` (Resource Group)   |
| `app_or_project`         | Identifier for the application or project.                                          | `qoh`           |
| `environment`            | Environment where the resource is deployed (`prod`, `dev`, `test`, etc.).           | `prod`                 |
| `region`                 | Azure region where the resource resides (e.g., `cus` for `centralus`).              | `cus`                  |
| `optional_unique_suffix` | Optional unique string for ensuring name uniqueness, often random or incremental.    | `abcd`, `a42n`                 |

## AKS SSH Keys

To create and configure SSH keys for accessing the AKS cluster:

1. **Create the directory** for storing SSH keys:
    ```bash
    mkdir $HOME/.ssh/VeeraBhadraDevOps
    ```

2. **Generate the SSH key pair**:
    ```bash
    ssh-keygen \
        -m PEM \
        -t rsa \
        -b 4096 \
        -C "VeeraBhadraDevOps@LAPTOP-XXXXXXX" \
        -f ~/.ssh/VeeraBhadraDevOps/VeeraBhadraDevOps_id_rsa \
        -N "mypassphrase"
    ```

3. **Verify** the keys are created:
    ```bash
    ls -lrt $HOME/.ssh/VeeraBhadraDevOps
    ```

## ACI Connector for AKS

To configure the AKS virtual node subnet with delegation for ACI (Azure Container Instances):

- Add a **delegation** to the subnet to ensure AKS works with ACI properly and to prevent future issues:
  
    ```hcl
    resource "azurerm_subnet" "virtual" {
    
      # Add your other subnet configurations here
      
      delegation {
        name = "aciDelegation"
        service_delegation {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
    ```

## Ingress Application Gateway

If using an **Application Gateway** as an ingress controller, ensure the following configuration:

- The **Application Gateway** is deployed inside a Virtual Network. The users (and Service Principals) operating the Application Gateway must have the `Microsoft.Network/virtualNetworks/subnets/join/action` permission on the Virtual Network or Subnet.

For more details, please refer to [Virtual Network Permissions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources#permissions).

- When using the **ingress_application_gateway**, at least one of the following parameters must be specified: `gateway_id`, `subnet_id`, or `subnet_cidr`.

**Note:**  
- If using **ingress_application_gateway** in conjunction with the `only_critical_addons_enabled` option, the **AGIC (Azure Application Gateway Ingress Controller)** pod will fail to start. In this case, create a separate `azurerm_kubernetes_cluster_node_pool` to run the AGIC pod successfully, as AGIC is classified as a "non-critical addon."

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_extension.aks_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension) | resource |
| [azurerm_kubernetes_cluster_node_pool.kubernetes_cluster_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_kubernetes_service_versions.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_service_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci_connector_linux"></a> [aci\_connector\_linux](#input\_aci\_connector\_linux) | (Optional) A aci\_connector\_linux block | `any` | `{}` | no |
| <a name="input_aks_extension"></a> [aks\_extension](#input\_aks\_extension) | AKS Extension | `any` | `{}` | no |
| <a name="input_api_server_access_profile"></a> [api\_server\_access\_profile](#input\_api\_server\_access\_profile) | (Optional) An api\_server\_access\_profile block | `any` | `{}` | no |
| <a name="input_auto_scaler_profile"></a> [auto\_scaler\_profile](#input\_auto\_scaler\_profile) | (Optional) A auto\_scaler\_profile block | `any` | `{}` | no |
| <a name="input_automatic_upgrade_channel"></a> [automatic\_upgrade\_channel](#input\_automatic\_upgrade\_channel) | (Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable. Omitting this field sets this value to none. | `string` | `null` | no |
| <a name="input_azure_active_directory_role_based_access_control"></a> [azure\_active\_directory\_role\_based\_access\_control](#input\_azure\_active\_directory\_role\_based\_access\_control) | (Optional) A azure\_active\_directory\_role\_based\_access\_control block | `any` | `{}` | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | (Optional) Should the Azure Policy Add-On be enabled? | `bool` | `null` | no |
| <a name="input_confidential_computing"></a> [confidential\_computing](#input\_confidential\_computing) | (Optional) A confidential\_computing block | `any` | `{}` | no |
| <a name="input_cost_analysis_enabled"></a> [cost\_analysis\_enabled](#input\_cost\_analysis\_enabled) | (Optional) Should cost analysis be enabled for this Kubernetes Cluster? Defaults to false. The sku\_tier must be set to Standard or Premium to enable this feature. Enabling this will add Kubernetes Namespace and Deployment details to the Cost Analysis views in the Azure portal. | `bool` | `false` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | (Required) A default\_node\_pool block | `any` | n/a | yes |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | (Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes. More information can be found in the documentation. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_dns_prefix_private_cluster"></a> [dns\_prefix\_private\_cluster](#input\_dns\_prefix\_private\_cluster) | (Optional) Specifies the DNS prefix to use with private clusters. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | (Optional) Specifies the Edge Zone within the Azure Region where this Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#input\_http\_application\_routing\_enabled) | (Optional) Should HTTP Application Routing be enabled? | `bool` | `null` | no |
| <a name="input_http_proxy_config"></a> [http\_proxy\_config](#input\_http\_proxy\_config) | (Optional) A http\_proxy\_config block | `any` | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block | `any` | `{}` | no |
| <a name="input_image_cleaner_enabled"></a> [image\_cleaner\_enabled](#input\_image\_cleaner\_enabled) | (Optional) Specifies whether Image Cleaner is enabled. | `bool` | `null` | no |
| <a name="input_image_cleaner_interval_hours"></a> [image\_cleaner\_interval\_hours](#input\_image\_cleaner\_interval\_hours) | (Optional) Specifies the interval in hours when images should be cleaned up. Defaults to 48. | `number` | `48` | no |
| <a name="input_ingress_application_gateway"></a> [ingress\_application\_gateway](#input\_ingress\_application\_gateway) | (Optional) A ingress\_application\_gateway block | `any` | `{}` | no |
| <a name="input_key_management_service"></a> [key\_management\_service](#input\_key\_management\_service) | (Optional) A key\_management\_service block | `any` | `{}` | no |
| <a name="input_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#input\_key\_vault\_secrets\_provider) | (Optional) A key\_vault\_secrets\_provider block | `any` | `{}` | no |
| <a name="input_kubelet_identity"></a> [kubelet\_identity](#input\_kubelet\_identity) | (Optional) A kubelet\_identity block | `any` | `{}` | no |
| <a name="input_kubernetes_cluster_node_pool"></a> [kubernetes\_cluster\_node\_pool](#input\_kubernetes\_cluster\_node\_pool) | One or more kubernetes\_cluster\_node\_pool blocks | `map` | `{}` | no |
| <a name="input_linux_profile"></a> [linux\_profile](#input\_linux\_profile) | (Optional) A linux\_profile block | `any` | `{}` | no |
| <a name="input_local_account_disabled"></a> [local\_account\_disabled](#input\_local\_account\_disabled) | (Optional) If true local accounts will be disabled. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Optional) A maintenance\_window block | `any` | `{}` | no |
| <a name="input_maintenance_window_auto_upgrade"></a> [maintenance\_window\_auto\_upgrade](#input\_maintenance\_window\_auto\_upgrade) | (Optional) A maintenance\_window\_auto\_upgrade block | `any` | `{}` | no |
| <a name="input_maintenance_window_node_os"></a> [maintenance\_window\_node\_os](#input\_maintenance\_window\_node\_os) | (Optional) A maintenance\_window\_node\_os block | `any` | `{}` | no |
| <a name="input_microsoft_defender"></a> [microsoft\_defender](#input\_microsoft\_defender) | (Optional) A microsoft\_defender block | `any` | `{}` | no |
| <a name="input_monitor_metrics"></a> [monitor\_metrics](#input\_monitor\_metrics) | (Optional) A monitor\_metrics block | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile) | (Optional) A network\_profile block | `any` | `{}` | no |
| <a name="input_node_os_upgrade_channel"></a> [node\_os\_upgrade\_channel](#input\_node\_os\_upgrade\_channel) | (Optional) The upgrade channel for this Kubernetes Cluster Nodes' OS Image. Possible values are Unmanaged, SecurityPatch, NodeImage and None. | `string` | `"NodeImage"` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | (Optional) The name of the Resource Group where the Kubernetes Nodes should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_nodepool_subnet_id"></a> [nodepool\_subnet\_id](#input\_nodepool\_subnet\_id) | AKS Nodepool Subnet ID | `string` | `null` | no |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled) | (Optional) Enable or Disable the OIDC issuer URL | `bool` | `null` | no |
| <a name="input_oms_agent"></a> [oms\_agent](#input\_oms\_agent) | (Optional) A oms\_agent block | `any` | `{}` | no |
| <a name="input_open_service_mesh_enabled"></a> [open\_service\_mesh\_enabled](#input\_open\_service\_mesh\_enabled) | (Optional) Is Open Service Mesh enabled? | `bool` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | (Optional) Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_private_cluster_public_fqdn_enabled"></a> [private\_cluster\_public\_fqdn\_enabled](#input\_private\_cluster\_public\_fqdn\_enabled) | (Optional) Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to false. | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | (Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise, the cluster will have issues after provisioning. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled) | (Optional) Whether Role Based Access Control for the Kubernetes Cluster should be enabled. Defaults to true. Changing this forces a new resource to be created. | `bool` | `true` | no |
| <a name="input_run_command_enabled"></a> [run\_command\_enabled](#input\_run\_command\_enabled) | (Optional) Whether to enable run command for the cluster or not. Defaults to true. | `bool` | `true` | no |
| <a name="input_service_mesh_profile"></a> [service\_mesh\_profile](#input\_service\_mesh\_profile) | (Optional) A service\_mesh\_profile block | `any` | `{}` | no |
| <a name="input_service_principal"></a> [service\_principal](#input\_service\_principal) | (Optional) A service\_principal block | `any` | `{}` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard (which includes the Uptime SLA) and Premium. Defaults to Free. | `string` | `null` | no |
| <a name="input_storage_profile"></a> [storage\_profile](#input\_storage\_profile) | (Optional) A storage\_profile block | `any` | `{}` | no |
| <a name="input_support_plan"></a> [support\_plan](#input\_support\_plan) | (Optional) Specifies the support plan which should be used for this Kubernetes Cluster. Possible values are KubernetesOfficial and AKSLongTermSupport. Defaults to KubernetesOfficial. | `string` | `"KubernetesOfficial"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(any)` | `{}` | no |
| <a name="input_web_app_routing"></a> [web\_app\_routing](#input\_web\_app\_routing) | (Optional) A web\_app\_routing block | `any` | `{}` | no |
| <a name="input_windows_profile"></a> [windows\_profile](#input\_windows\_profile) | (Optional) A windows\_profile block | `any` | `{}` | no |
| <a name="input_workload_autoscaler_profile"></a> [workload\_autoscaler\_profile](#input\_workload\_autoscaler\_profile) | (Optional) A workload\_autoscaler\_profile block | `any` | `{}` | no |
| <a name="input_workload_identity_enabled"></a> [workload\_identity\_enabled](#input\_workload\_identity\_enabled) | (Optional) Specifies whether Azure AD Workload Identity should be enabled for the Cluster. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_version"></a> [default\_version](#output\_default\_version) | The N-1 minor non-preview version and latest patch. |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_kubernetes_cluster_node_pool"></a> [kubernetes\_cluster\_node\_pool](#output\_kubernetes\_cluster\_node\_pool) | --------------- AKS Node Pool --------------- |
| <a name="output_latest_version"></a> [latest\_version](#output\_latest\_version) | The most recent version available. If include\_preview == false, this is the most recent non-preview version available. |
| <a name="output_name"></a> [name](#output\_name) | -------------------------- Azure Kubernetes Cluster -------------------------- |
| <a name="output_versions"></a> [versions](#output\_versions) | The list of all supported versions. |
