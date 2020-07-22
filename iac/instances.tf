resource "google_compute_instance" "ece-01" {
 name         = var.instance1
 machine_type = var.machine_type
 zone         = var.zone1
 hostname     = var.hostname1

 boot_disk {
   initialize_params {
     image = var.image
     size  = var.disk_size
   }
 }

 network_interface {
   network    = "default"
   network_ip = var.ip1
   access_config {}
 }
 metadata = {
   ssh-keys = "${var.user}:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance" "ece-02" {
 name         = var.instance2
 machine_type = var.machine_type
 zone         = var.zone2
 hostname     = var.hostname2

 boot_disk {
   initialize_params {
     image = var.image
     size  = var.disk_size
   }
 }

 network_interface {
   network    = "default"
   network_ip = var.ip2
   access_config {}
 }
 metadata = {
   ssh-keys = "${var.user}:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance" "ece-03" {
 name         = var.instance3
 machine_type = var.machine_type
 zone         = var.zone3
 hostname     = var.hostname3

 boot_disk {
   initialize_params {
     image = var.image
     size  = var.disk_size
   }
 }

 network_interface {
   network    = "default"
   network_ip = var.ip3
   access_config {}
 }
 metadata = {
   ssh-keys = "${var.user}:${file(var.ssh_key)}"
 }
}