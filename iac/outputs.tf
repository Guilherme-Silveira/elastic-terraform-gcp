output "lb_address" {
  value = google_compute_global_forwarding_rule.default.ip_address
}

output "elastic-01" {
  value = google_compute_instance.elastic-01.network_interface.0.access_config.0.nat_ip
}

output "elastic-02" {
  value = google_compute_instance.elastic-02.network_interface.0.access_config.0.nat_ip
}

output "elastic-03" {
  value = google_compute_instance.elastic-03.network_interface.0.access_config.0.nat_ip
}

