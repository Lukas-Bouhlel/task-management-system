variable "instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "disk_image" {
  type = string
}

variable "ssh_public_key" {
  description = "Path to SSH public key file"
  type        = string
}