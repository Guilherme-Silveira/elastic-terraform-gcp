resource "null_resource" "hosts" {
 triggers = {
   anything1 = google_compute_instance.ece-01.network_interface.0.access_config.0.nat_ip
   anything2 = google_compute_instance.ece-02.network_interface.0.access_config.0.nat_ip
   anything3 = google_compute_instance.ece-03.network_interface.0.access_config.0.nat_ip
 }
 provisioner "remote-exec" {
   connection {
     type = "ssh"
     user = var.user
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
     user = var.user
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
     user = var.user
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
     user = var.bastion_user
     host = var.bastion_ip
     private_key = file(var.bastion_private_key)
   }
   inline = [
     "cd /home/silveira/elastic-terraform-gcp/ansible",
     "cat << EOF > hosts",
     "[cluster]",
     "elastic-01 ansible_host=${var.ip1} hostname=${var.hostname1} host=${var.instance1}",
     "elastic-02 ansible_host=${var.ip2} hostname=${var.hostname2} host=${var.instance2}",
     "elastic-03 ansible_host=${var.ip3} hostname=${var.hostname3} host=${var.instance3}",
     "[all:vars]",
     "ansible_user=${var.user}",
     "ansible_ssh_private_key_file=${var.ansible_private_key}",
     "ansible_become=yes",
     "EOF",
     "ansible-playbook -i hosts elastic.yml",
   ]
 }
}