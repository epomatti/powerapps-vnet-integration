### General ###
variable "subscription_id" {
  type = string
}

variable "primary_location" {
  type = string
}

variable "secondary_location" {
  type = string
}

variable "project" {
  type = string
}

variable "allowed_public_ips" {
  type = list(string)
}

### Virtual Networks ###
variable "primary_vnet_cidr_prefix" {
  type = string
}

variable "secondary_vnet_cidr_prefix" {
  type = string
}

### Database ###
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
variable "create_powerapps_enterprise_policy" {
  type = bool
}

variable "create_powerapps_environment" {
  type = bool
}

variable "powerplatform_environment_location" {
  type = string
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_sqldeveloper_user_password" {
  type = string
}

### On-Premises Data Gateway ###
variable "create_gateway" {
  type = bool
}

variable "gateway_size" {
  type = string
}

variable "gateway_publisher" {
  type = string
}

variable "gateway_offer" {
  type = string
}

variable "gateway_sku" {
  type = string
}

variable "gateway_version" {
  type = string
}
