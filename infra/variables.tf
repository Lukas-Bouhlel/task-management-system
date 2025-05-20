variable "region" {
  type    = string
  default = "europe-west1"
}

variable "project_id" {
  type    = string
  default = "skilled-nation-460410-m3"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "instance_name" {
  type    = string
  default = "node-api-vm"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "disk_image" {
  type    = string
  default = "debian-cloud/debian-11"
}

variable "credentials_file" {
  description = "Path to the Google Cloud credentials JSON file"
  type        = string
}