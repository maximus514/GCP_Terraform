module "project_services" {
  source     = "./modules/project_services"
  project_id = var.project_id
}

module "network" {
  source = "./modules/network"
  zone   = var.zone
  region = var.region
}

module "compute" {
  source       = "./modules/compute"
  name         = var.name
  cluster_name = var.cluster_name
  zone         = var.zone
  machine_type = var.machine_type
  network_self_link = module.network.network_self_link
  subnet_self_link  = module.network.subnet_self_link
}

