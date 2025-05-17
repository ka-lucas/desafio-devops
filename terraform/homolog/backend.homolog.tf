terraform {
  backend "gcs" {
    bucket = "devops-terraform-state"
    prefix = "homolog"
  }
}
