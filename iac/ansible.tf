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
      "cd ${var.ansible_home}",
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
      "cat << EOF > elastic.yml",
      "---",
      "- hosts: cluster",
      "  roles:",
      "    - role: geerlingguy.java",
      "      when: ansible_os_family == 'RedHat'",
      "      java_packages:",
      "        - java-1.8.0-openjdk",
      "- hosts: cluster",
      "  roles:",
      "    - role: build_hosts",
      "- hosts: elastic-01",
      "  roles:",
      "    - role: elastic.elasticsearch",
      "  vars:",
      "    es_version: ${var.es_version}",
      "    es_heap_size: '${var.es_heap_size}'",
      "    es_config:",
      "      cluster.name: '${var.cluster_name}'",
      "      cluster.initial_master_nodes: '${var.instance1},${var.instance2},${var.instance3}'",
      "      discovery.seed_hosts: '${var.instance1},${var.instance2},${var.instance3}'",
      "      http.port: 9200",
      "      bootstrap.memory_lock: false",
      "      network.host: _site_",
      "      node.name: ${var.instance1}",
      "    es_api_host: '${var.ip1}'",
      "- hosts: elastic-02",
      "  roles:",
      "    - role: elastic.elasticsearch",
      "  vars:",
      "    es_version: ${var.es_version}",
      "    es_heap_size: '${var.es_heap_size}'",
      "    es_config:",
      "      cluster.name: '${var.cluster_name}'",
      "      cluster.initial_master_nodes: '${var.instance1},${var.instance2},${var.instance3}'",
      "      discovery.seed_hosts: '${var.instance1},${var.instance2},${var.instance3}'",
      "      http.port: 9200",
      "      bootstrap.memory_lock: false",
      "      network.host: _site_",
      "      node.name: ${var.instance2}",
      "    es_api_host: '${var.ip2}'",
      "- hosts: elastic-03",
      "  roles:",
      "    - role: elastic.elasticsearch",
      "  vars:",
      "    es_version: ${var.es_version}",
      "    es_heap_size: '${var.es_heap_size}'",
      "    es_config:",
      "      cluster.name: '${var.cluster_name}'",
      "      cluster.initial_master_nodes: '${var.instance1},${var.instance2},${var.instance3}'",
      "      discovery.seed_hosts: '${var.instance1},${var.instance2},${var.instance3}'",
      "      http.port: 9200",
      "      bootstrap.memory_lock: false",
      "      network.host: _site_",
      "      node.name: ${var.instance3}",
      "    es_api_host: '${var.ip3}'",
      "- hosts: elastic-01",
      "  roles:",
      "    - role: geerlingguy.kibana",
      "  vars:",
      "    - kibana_elasticsearch_url: '[http://${var.instance1}:9200,http://${var.instance2}:9200,http://${var.instance3}:9200]'",
      "    - kibana_version: '7.x'",
      "    - kibana_package_state: 'present'",
      "    - kibana_package: 'kibana-${var.es_version}'",
      "- hosts: elastic-02",
      "  roles:",
      "    - role: geerlingguy.logstash",
      "  vars:",
      "    - logstash_version: '7.x'",
      "    - logstash_package: 'logstash-${var.es_version}'",
      "EOF",
      "ansible-playbook -i hosts elastic.yml",
   ]
 }
}
