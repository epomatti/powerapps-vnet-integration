### General ###
primary_location   = "brazilsouth"
secondary_location = "southcentralus"
project            = "litware"

subscription_id    = "<SUBSCRIPTION ID>"
allowed_public_ips = ["<YOUR IP ADDRESS>"]

### Virtual Networking ###
primary_vnet_cidr_prefix   = "10.10"
secondary_vnet_cidr_prefix = "10.20"

### Database ###
mssql_public_network_access_enabled = true
mssql_sku                           = "Basic"
mssql_max_size_gb                   = 2
mssql_admin_login                   = "sqladmin"
mssql_admin_login_password          = "P4ssw0rd!2023"
mssql_azuread_authentication_only   = false

### Power Apps ###
create_powerapps_enterprise_policy = true
create_powerapps_environment       = false
powerplatform_environment_location = "brazil" # "brazil", "unitedstates"

### Entra ID ###
entraid_tenant_domain              = "<ENTRA ID DOMAIN>"
entraid_sqldeveloper_user_password = "P4ssw0rd!2023"

# Data Gateway
create_gateway    = false
gateway_size      = "Standard_D2_v3"
gateway_publisher = "MicrosoftWindowsServer"
gateway_offer     = "WindowsServer"
gateway_sku       = "2025-datacenter-g2"
gateway_version   = "latest"
