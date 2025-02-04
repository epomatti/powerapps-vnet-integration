terraform {
  required_providers {
    powerplatform = {
      source = "microsoft/power-platform"
    }
  }
}

# provider "powerplatform" {
#   use_cli = true
# }

# provider "azurerm" {
#   features {}
#   use_cli = true
# }

data "azurerm_client_config" "current" {
}

locals {
  current_subscription_id = data.azurerm_client_config.current.subscription_id
}

resource "powerplatform_billing_policy" "default" {
  name     = "PayAsYouGoBillingPolicy"
  location = var.powerapps_location
  status   = "Enabled"

  billing_instrument = {
    resource_group  = var.primary_resource_group_name
    subscription_id = local.current_subscription_id
  }
}

# resource "powerplatform_environment" "sandbox" {
#   display_name     = "AzureSandbox"
#   location         = "europe"
#   azure_region     = var.location
#   environment_type = "Sandbox"

#   dataverse = {
#     language_code = "1033"
#     currency_code = "USD"
#     # domain            = "mydomain"
#     # security_group_id = "00000000-0000-0000-0000-000000000000"
#   }
# }

# resource "powerplatform_managed_environment" "sandbox" {
#   environment_id             = powerplatform_environment.sandbox.id
#   is_usage_insights_disabled = true
#   is_group_sharing_disabled  = true
#   limit_sharing_mode         = "ExcludeSharingToSecurityGroups"
#   max_limit_user_sharing     = 10
#   solution_checker_mode      = "None"
#   suppress_validation_emails = true
#   maker_onboarding_markdown  = "this is example markdown"
#   maker_onboarding_url       = "https://www.microsoft.com"
# }
