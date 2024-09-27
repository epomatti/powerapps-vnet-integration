variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "sku" {
  type = string
}

variable "max_size_gb" {
  type = number
}

variable "admin_login" {
  type = string
}

variable "admin_login_password" {
  type      = string
  sensitive = true
}

variable "public_network_access_enabled" {
  type = bool
}

variable "allowed_public_ips" {
  type = list(string)
}
