module "project_services" {
  source     = "./modules/project_services"
  project_id = var.project_id
}

module "network" {
  source = "./modules/network"
  zone   = var.zones[0] # Use the first zone from the list
  region = var.region
  vpc-name = var.vpc-name
  subnet-name = var.subnet-name
}

module "compute" {
  source       = "./modules/compute"
  name         = var.name
  cluster_name = var.name
  region       = var.region
  zone         = var.zones[0] # Use the first zone from the list
  machine_type = var.machine_type
  network_self_link = module.network.network_self_link
  subnet_self_link  = module.network.subnet_self_link
}

