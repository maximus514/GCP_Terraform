
# -------------------------
# Health Check
# -------------------------
resource "google_compute_http_health_check" "web_hc" {
  name               = "web-health-check"
  request_path       = "/"
  check_interval_sec = 30
  timeout_sec        = 5
}

# -------------------------
# Backend Service
# -------------------------
resource "google_compute_backend_service" "web_backend" {
  name          = "web-backend-service"
  protocol      = "HTTP"
  port_name     = "http"
  timeout_sec   = 10
  health_checks = [google_compute_http_health_check.web_hc.self_link]

  backend {
    group = var.instance_group_self_link
  }
  depends_on = [
    var.instance_group_self_link
  ]
}

# -------------------------
# URL Map
# -------------------------
resource "google_compute_url_map" "web_url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.web_backend.self_link
}

# -------------------------
# Target HTTP Proxy
# -------------------------
resource "google_compute_target_http_proxy" "web_proxy" {
  name    = "web-http-proxy"
  url_map = google_compute_url_map.web_url_map.self_link
}

# -------------------------
# Global Forwarding Rule
# -------------------------
resource "google_compute_global_forwarding_rule" "web_forwarding_rule" {
  name       = "web-global-forwarding-rule"
  target     = google_compute_target_http_proxy.web_proxy.self_link
  port_range = "80"
}