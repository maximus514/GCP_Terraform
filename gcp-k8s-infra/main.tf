# -------------------------
# Provider Configuration
# -------------------------
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zones[0] # Use the first zone from the list
}
