terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

resource "azapi_resource" "network_injection_enterprise_policy" {
  type      = "Microsoft.PowerPlatform/enterprisePolicies@2020-10-30-preview"
  name      = "vnetEP-${var.workload}"
  location  = var.powerapps_location
  parent_id = var.resource_group_id

  # https://github.com/Azure/bicep-types-az/issues/2251
  # schema_validation_enabled = false

  body = jsonencode({
    "properties" : {
      "networkInjection" : {
        "virtualNetworks" : [
          {
            "id" : "${var.primary_vnet_id}",
            "subnet" : {
              "name" : "${var.primary_subnet_name}"
            }
          },
          {
            "id" : "${var.secondary_vnet_id}",
            "subnet" : {
              "name" : "${var.secondary_subnet_name}"
            }
          }
        ]
      }
    },
    "kind" : "NetworkInjection"
  })

}
