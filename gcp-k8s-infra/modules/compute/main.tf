resource "google_container_cluster" "cluster_1" {

  name     = var.cluster_name
  location = "us-central1"

  node_locations = [
    "us-central1-a",
    "us-central1-b"
  ]

  initial_node_count = 1

  min_master_version = "1.34.4-gke.1047000"

  network    = var.network_self_link
  subnetwork = var.subnet_self_link

  deletion_protection = false
  
  release_channel {
    channel = "REGULAR"
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

    # node_local_dns block removed as it is not supported in google_container_cluster resource

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

  node_config {

    machine_type = "e2-medium"
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-standard"
    disk_size_gb = 100

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

    binary_authorization {
      evaluation_mode = "DISABLED"
    }
  }
