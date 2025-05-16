
provider "google" {
  project = "devops-459516"
  region  = "us-central1"
}

env {
  name  = "NAME"
  value = "Production"
}


resource "google_cloud_run_service" "prod" {
  name     = "desafio-api-prod"
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
  service  = google_cloud_run_service.prod.name
  location = google_cloud_run_service.prod.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
