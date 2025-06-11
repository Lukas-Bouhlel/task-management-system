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
  region         = var.region 
}

resource "google_compute_resource_policy" "daily_snapshot" {
  name   = "daily-snapshot-policy"
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time = "04:00"
      }
    }
    retention_policy {
      max_retention_days = 7
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    snapshot_properties {
      labels = {
        my_label = "value"
      }
      storage_locations = ["us"]
      guest_flush = false
    }
  }
}