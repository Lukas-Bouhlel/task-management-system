provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

module "vm" {
  source         = "./modules/vm"
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  zone           = var.zone
  disk_image     = var.disk_image
  ssh_public_key = var.ssh_public_key
}