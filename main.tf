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

# Создаём 3 статических IP-адреса
resource "google_compute_address" "static_ip" {
  count  = 3
  name   = "vm-ip-${count.index}"
  region = "us-central1"
}

# Создаём 3 ВМ
resource "google_compute_instance" "vm" {
  count         = 3
  name          = "cloud-${count.index + 1}"
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
      nat_ip = google_compute_address.static_ip[count.index].address
    }
  }
}

# Файл hosts с IP всех ВМ
resource "local_file" "ansible_hosts" {
  content = <<EOF
[${var.ansible_group}]
%{for i in range(3)} cloud-${i + 1} ansible_host=${google_compute_address.static_ip[i].address}
%{endfor}
EOF
  filename = "hosts"
}

# Файл group_vars
resource "local_file" "ansible_group_vars" {
  filename = "./group_vars/${var.ansible_group}.yaml"
  content  = <<EOF
owner:       ${var.ssh_user}
${var.ansible_param[0]}:      ${var.ssh_user}
docker_repo: ${var.docker_repo}
GPG_key:     ${var.GPG_key}
EOF
}

