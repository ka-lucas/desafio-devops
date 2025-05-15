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
          value = "Homolog"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Service Account exclusiva para invocar o Cloud Run
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
