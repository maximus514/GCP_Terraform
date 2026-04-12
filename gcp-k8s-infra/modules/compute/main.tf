resource "google_container_cluster" "cluster_1" {

  name     = var.cluster_name
  location = var.region
  initial_node_count = 1
  remove_default_node_pool = true
  node_locations = [var.zones[0], var.zones[1]]

  min_master_version = "1.34.4-gke.1047000"

  network    = var.network_self_link
  subnetwork = var.subnet_self_link

  deletion_protection = false

  release_channel {
    channel = "REGULAR"
  }
  gateway_api_config {
    channel = "STANDARD"
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/21"
    services_ipv4_cidr_block = "10.0.2.0/23"
  }

  default_max_pods_per_node = 110

  datapath_provider = "ADVANCED_DATAPATH"

  security_posture_config {
    mode = "BASIC"
  }

  addons_config {

    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  enable_shielded_nodes = true

  enable_intranode_visibility = false

  workload_identity_config {
    workload_pool = "maximus-dev-01.svc.id.goog"
  }

  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {

  name       = "primary-node-pool"
  cluster    = google_container_cluster.cluster_1.name
  location   = var.region

  node_config {
    machine_type = var.machine_type
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-standard"
    disk_size_gb = 100
    preemptible  = false
  }
  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }
}