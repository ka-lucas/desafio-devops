provider "google" {
  project = "devops-459516"
  region  = "us-central1"
}

# Serviço Cloud Run
resource "google_cloud_run_service" "homolog" {
  name     = "desafio-api-homolog"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/devops-459516/desafio-api"

        ports {
          container_port = 8080
        }

        env {
          name  = "NAME"
          value = "World"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "cloud-run-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_run {
    service = google_cloud_run_service.homolog.name
  }
}

#Service Account exclusiva para invocar o Cloud Run
resource "google_service_account" "invoker" {
  account_id   = "cloud-run-invoker"
  display_name = "Cloud Run Invoker"
}

# Permissão de invocação do serviço para a Service Account criada
resource "google_cloud_run_service_iam_member" "invoker_access" {
  service  = google_cloud_run_service.homolog.name
  location = google_cloud_run_service.homolog.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.invoker.email}"
}

resource "google_compute_security_policy" "ip_restrict" {
  name        = "allow-my-ip"
  description = "Allow only specific IPs"
}


resource "google_compute_backend_service" "default" {
  name                  = "cloud-run-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_name             = "http"
  timeout_sec           = 30
  enable_cdn            = false

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }

  security_policy = google_compute_security_policy.ip_restrict.id
}

resource "google_compute_global_address" "cloud_run_ip" {
  name = "cloud-run-ip"
}

resource "google_compute_url_map" "default" {
  name            = "cloud-run-url-map"
  default_service = google_compute_backend_service.default.id
}
resource "google_compute_target_http_proxy" "default" {
  name    = "cloud-run-proxy"
  url_map = google_compute_url_map.default.id
}
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "cloud-run-forwarding-rule"
  target                = google_compute_target_http_proxy.default.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.cloud_run_ip.address
}
