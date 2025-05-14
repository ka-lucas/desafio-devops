provider "google" {
  project = "devops-459516"
  region  = "us-central1"
}

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
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.homolog.name
  location = google_cloud_run_service.homolog.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
