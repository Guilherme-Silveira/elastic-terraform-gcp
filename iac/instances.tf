resource "google_compute_instance" "elastic-01" {
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
   network    = var.network
   network_ip = var.ip1
   access_config {}
 }
 metadata = {
   ssh-keys = "${var.user}:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance" "elastic-02" {
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
   network    = var.network
   network_ip = var.ip2
   access_config {}
 }
 metadata = {
   ssh-keys = "${var.user}:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance" "elastic-03" {
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
   network    = var.network
   network_ip = var.ip3
   access_config {}
 }
 metadata = {
   ssh-keys = "${var.user}:${file(var.ssh_key)}"
 }
}

resource "google_compute_instance_group" "kibana-01" {
  name        = "kibana-group-01"

  instances = [
    google_compute_instance.elastic-01.id
  ]

  named_port {
    name = "http"
    port = "5601"
  }

  zone = google_compute_instance.elastic-01.zone
}

resource "google_compute_instance_group" "kibana-02" {
  name        = "kibana-group-02"

  instances = [
    google_compute_instance.elastic-02.id
  ]

  named_port {
    name = "http"
    port = "5601"
  }

  zone = google_compute_instance.elastic-02.zone
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
}

resource "google_compute_target_http_proxy" "default" {
  name        = "target-proxy"
  url_map     = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "url-map-target-proxy"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name        = "backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group                 = google_compute_instance_group.kibana-01.self_link
    balancing_mode        = "RATE"
    capacity_scaler       = 0.4
    max_rate_per_instance = 50
  }

  backend {
    group                 = google_compute_instance_group.kibana-02.self_link
    balancing_mode        = "RATE"
    capacity_scaler       = 0.4
    max_rate_per_instance = 50
  }

  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name               = "check-backend"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "5601"
  }
} 
