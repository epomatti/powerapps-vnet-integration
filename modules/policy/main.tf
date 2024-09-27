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

  body = jsonencode({
    "kind" : "NetowrkInjection",
    "properties" : {
      "networkInjection" : {
        "virtualNetworks" : {
          "value" : [
            {
              "id" : "${var.vnet_id}",
              "subnet" : {
                "name" : "${var.powerapps_subnet_name}"
              }
            }
          ]
        }
      }
    }
  })

}
