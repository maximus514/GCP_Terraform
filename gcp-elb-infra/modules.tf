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
  zone         = var.zone
  machine_type = var.machine_type
  subnet_id    = module.network.subnet_id
}

module "load_balancer" {
  source = "./modules/load_balancer"
  zone                     = var.zone
  subnet_id                = module.network.subnet_id
  instance_group_self_link = module.compute.instance_group_self_link
}