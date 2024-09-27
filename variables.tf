variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "pair_location" {
  type = string
}

variable "project" {
  type = string
}

variable "allowed_public_ips" {
  type = list(string)
}

variable "mssql_sku" {
  type = string
}

variable "mssql_max_size_gb" {
  type = number
}

variable "mssql_public_network_access_enabled" {
  type = bool
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type = string
}

variable "mssql_azuread_authentication_only" {
  type = bool
}

### Power Apps ###
variable "create_powerapps_environment" {
  type    = bool
  default = false
}

variable "powerplatform_environment_location" {
  type = string
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_sqldeveloper_user_password" {
  type      = string
  sensitive = true
}
