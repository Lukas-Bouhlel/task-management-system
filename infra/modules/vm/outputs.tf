output "vm_ip" {
  description = "Public IP address of the VM"
  value       = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

output "boot_disk_self_link" {
  value = google_compute_instance.default.boot_disk[0].source
}

output "boot_disk_name" {
  value = google_compute_instance.default.boot_disk[0].device_name
}