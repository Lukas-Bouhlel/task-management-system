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
    network = "default"
    access_config {} # IP externe
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
    ports    = ["22", "3000"] # SSH + port API
  }

  source_ranges = ["0.0.0.0/0"] # à limiter en prod
}

resource "google_compute_resource_policy" "daily_snapshot" {
  name   = "daily-snapshot-policy"
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time = "04:00"  # Spécifiez l'heure de début pour le snapshot
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    snapshot_properties {
      labels = {
        my_label = "value"
      }
      storage_locations = ["us"]
      guest_flush       = false
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "disk_attachment" {
  disk = "node-api-vm"
  name = "daily-snapshot-policy"
  zone = "europe-west1-b"
}