variable "region" {
    default = "ap-south-1"
}

variable "vpc_id" {}

variable "subnet_ids_broker" {
  type = list(string)
}
variable "subnet_ids_consumer"{
  type = string
}

variable "key_names" {}

variable "instance_type" {
  default = "t3a.small"
}

variable "broker_count" {
  default = 2
}