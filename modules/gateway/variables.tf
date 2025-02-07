variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "gateway_admin_username" {
  type = string
}

variable "gateway_admin_password" {
  type      = string
  sensitive = true
}

variable "subnet_id" {
  type = string
}

variable "zone" {
  type = string
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
