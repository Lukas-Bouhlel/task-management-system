resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network       = "default"
    access_config {}  # IP externe
  }

  metadata = {
    ssh-keys = "lukasbouhlel:${file(var.ssh_public_key)}"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nodejs npm
    # tu peux ici cloner ton repo ou déployer ton app
  EOT
}

resource "google_compute_firewall" "allow_http_ssh" {
  name    = "${var.instance_name}-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "3000"]  # SSH + port API
  }

  source_ranges = ["0.0.0.0/0"]  # à limiter en prod
}