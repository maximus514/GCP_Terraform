# -------------------------
# VM Instance
# -------------------------
resource "google_compute_instance" "vm" {
  name         = "web-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["web", "ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    echo "Waiting for apt processes..."

    while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 \
      || sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 \
      || sudo fuser /var/cache/apt/archives/lock >/dev/null 2>&1 \
      || sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1
    do
      echo "Waiting for apt locks..."
      sleep 30
    done

    echo "Updating packages"
    apt-get update -y

    echo "Installing nginx"
    apt-get install -y nginx

    HOSTNAME=$(curl -H "Metadata-Flavor: Google" \
    http://metadata.google.internal/computeMetadata/v1/instance/hostname)

    cat <<HTML > /var/www/html/index.html
    <h1>Served by:</h1>
    <p>Hostname: $HOSTNAME</p>
    HTML

    systemctl enable nginx
    systemctl start nginx

    EOF
}

# -------------------------
# Instance Group for Load Balancer
# -------------------------
resource "google_compute_instance_group" "web_ig" {
  name      = "web-instance-group"
  zone      = var.zone
  instances = [google_compute_instance.vm.self_link]

  named_port {
    name = "http"
    port = 80
  }
}
