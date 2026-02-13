variable "container_name_prefix" {
  description = "Prefix for the container names"
  type        = string
  default     = "TFLab-Web"
}

variable "internal_port" {
  type    = number
  default = 80
}

variable "external_port_start" {
  type    = number
  default = 8080
}
