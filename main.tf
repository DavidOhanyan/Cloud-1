provider "google" {
  credentials   = file("./acces_key_gcp.json")
  project       = "learning-442712"
  region        = "us-central1"
  zone          = "us-central1-a"
}

terraform {
  backend "local" {
    path = "./states/terraform.tfstate"
  }
}

resource "google_compute_address" "static_ip" {
  name   = "my-web-ip"
  region = "us-central1"
}

locals {
  ip_address = google_compute_address.static_ip.address
}

resource "google_compute_instance" "my_instance" {
  name          = "cloud-1"
  machine_type  = "e2-medium"
  zone          = "us-central1-a"

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["inception", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
}

resource "google_compute_firewall" "allow-http-https" {
  name    = "allow-http-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["inception", "http-server", "https-server"]
}

resource "local_file" "ansible_host" {
  content  =<<EOF
 [${var.ansible_group}]

 ${var.server_nick} ${var.ansible_param[1]}=${local.ip_address}
  EOF
  filename = "hosts"
}

resource "local_file" "ansible_group_vasr_file" {
  count = fileexists("${path.module}/group_vars/${var.ansible_group}.yaml") ? 0 : 1
  filename = "${path.module}/group_vars/${var.ansible_group}.yaml"
  content  = ""
}
