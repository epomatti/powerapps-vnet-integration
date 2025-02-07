variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cidr_prefix" {
  type = string
}

variable "gateway_allowed_public_ips" {
  type = list(string)
}
