terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = file(var.credentials_file)
}

resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["web", "ssh"]

  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys       = "${var.ssh_username}:${chomp(file(var.ssh_public_key_path))}"
    enable-oslogin = "FALSE"
  }

  metadata_startup_script = <<-EOT
    #!/usr/bin/env bash
    set -euo pipefail
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release fail2ban
    curl -fsSL https://get.docker.com -o /root/get-docker.sh
    sh /root/get-docker.sh
    rm /root/get-docker.sh
    if id ubuntu >/dev/null 2>&1; then usermod -aG docker ubuntu; fi
    docker network create proxy >/dev/null 2>&1 || true
    docker run -d --name nginx-proxy --restart unless-stopped -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock:ro --net proxy nginxproxy/nginx-proxy:1.0-alpine
    systemctl enable --now fail2ban
  EOT
}

resource "google_compute_firewall" "allow_web" {
  name          = "${var.instance_name}-allow-web"
  network       = "default"
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "${var.instance_name}-allow-ssh"
  network       = "default"
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}
