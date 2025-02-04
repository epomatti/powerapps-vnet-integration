location      = "eastus"
pair_location = "westus"
project       = "litware"

subscription_id    = ""
allowed_public_ips = [""]

mssql_public_network_access_enabled = true
mssql_sku                           = "Basic"
mssql_max_size_gb                   = 2
mssql_admin_login                   = "sqladmin"
mssql_admin_login_password          = "P4ssw0rd!2023"
mssql_azuread_authentication_only   = false

create_powerapps_environment       = false
create_powerapps_enterprise_policy = false
powerplatform_environment_location = "unitedstates"

entraid_tenant_domain              = ""
entraid_sqldeveloper_user_password = "P4ssw0rd!2023"

# Data Gateway
create_gateway    = false
gateway_size      = "Standard_D2_v3"
gateway_publisher = "MicrosoftWindowsServer"
gateway_offer     = "WindowsServer"
gateway_sku       = "2025-datacenter-g2"
gateway_version   = "latest"
