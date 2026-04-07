resource "google_artifact_registry_repository" "nginx_repo" {
  provider = google

  project       = var.project_id
  location      = "us-central1"
  repository_id = "nginx-repo"
  description   = "Docker repository for nginx images"
  format        = "DOCKER"
}