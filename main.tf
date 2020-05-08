variable "instance1" {
 type = string
}

variable "instance2" {
 type = string
}

variable "instance3" {
 type = string
}

variable "zone" {
 type = string
}

variable "disk_size" {
 type = string
}

variable "bastion_ip" {
  type = string
}

variable "private_key" {
 type = string
}

variable "ssh_key" {
 type = string
}

provider "google" {
 credentials = file("../credentials.json")
 project     = "inlaid-lane-270316"
 region      = var.zone
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "ece-01" {
 name         = var.instance1
 machine_type = "n1-standard-2"
 zone         = "${var.zone}-a"
 hostname     = "${var.instance1}.srv"

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7"
     size  = var.disk_size
   }
 }

 network_interface {
   network    = "default"
   network_ip = "10.150.0.10"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 metadata = {
   ssh-keys = "silveira:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance" "ece-02" {
 name         = var.instance2
 machine_type = "n1-standard-2"
 zone         = "${var.zone}-b"
 hostname     = "${var.instance2}.srv"

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7"
     size  = var.disk_size
   }
 }

 network_interface {
   network    = "default"
   network_ip = "10.150.0.11"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 metadata = {
   ssh-keys = "silveira:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance" "ece-03" {
 name         = var.instance3
 machine_type = "n1-standard-2"
 zone         = "${var.zone}-c"
 hostname     = "${var.instance3}.srv"

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7"
     size  = var.disk_size
   }
 }

 network_interface {
   network    = "default"
   network_ip = "10.150.0.12"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 metadata = {
   ssh-keys = "silveira:${file(var.ssh_key)}"
 }
}

resource "null_resource" "hosts" {
 triggers = {
   anything1 = google_compute_instance.ece-01.network_interface.0.access_config.0.nat_ip
   anything2 = google_compute_instance.ece-02.network_interface.0.access_config.0.nat_ip
   anything3 = google_compute_instance.ece-03.network_interface.0.access_config.0.nat_ip
 }
 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = "silveira"
     host = google_compute_instance.ece-01.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK",

   ]
 }
 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = "silveira"
     host = google_compute_instance.ece-02.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK",
   ]
 }
 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = "silveira"
     host = google_compute_instance.ece-03.network_interface.0.access_config.0.nat_ip
     private_key = file(var.private_key)
   }
   inline = [
     "echo OK",
   ]
 }
 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = "silveira"
     host = var.bastion_ip
     private_key = file(var.private_key)
   }
   inline = [
     "cd /home/silveira/elastic-terraform-gcp/ansible",
     "ansible-playbook -i hosts playbooks/elastic.yml",
   ]
 }
}

