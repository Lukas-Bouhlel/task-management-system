resource "google_compute_snapshot" "default" {
  name        = "snapshot-${var.instance_name}"
  source_disk = module.vm.boot_disk_self_link
  zone        = var.zone
  description = "Snapshot of the ${var.instance_name} disk"
}

resource "google_compute_disk_resource_policy_attachment" "disk_attachment" {
  disk = "node-api-vm"
  name = "daily-snapshot-policy"
  zone = "europe-west1-b"
}