# Cloud-1: Automated Deployment of Inception
## Overview
The Cloud-1 project automates the deployment of a WordPress website and its associated infrastructure using Google Cloud Platform (GCP). The deployment is orchestrated using Terraform for infrastructure provisioning and Ansible for configuration management. This project ensures that each service (WordPress, MySQL, PHPMyAdmin, etc.) runs in its own isolated Docker container, providing a scalable and secure web hosting environment.

The application is designed to run on multiple instances on GCP, with the deployment process automated for efficiency. This README will guide you through the infrastructure provisioning and deployment process.
i
## Technologies Used
- `Terraform`: Used for cloud resource provisioning (e.g., virtual machines, static IPs, security groups/firewalls).
- `Ansible`: Automates the configuration and deployment process on provisioned cloud instances.
- `Docker`: Used for containerizing the WordPress application, MySQL database, PHPMyAdmin, etc.
- `GCP`: The cloud platforms chosen for hosting the infrastructure.
- `Ubuntu 20.04 LTS`: The operating system used on the provisioned instances.

## Prerequisites
Ensure the following are installed and configured:
- `Terraform` for provisioning cloud infrastructure.
- `Ansible` for automating the configuration management and service deployment.
- `GCP Account`: Cloud provider accounts with sufficient permissions to create instances and manage infrastructure.
- `SSH Key` for accessing cloud instances remotely.
- `Docker` & `Docker Compose` for managing the containerized services.

## Infrastructure Setup
### Step 1: Provisioning Cloud Infrastructure
Terraform is used to provision the infrastructure, which includes creating virtual machines, static IPs, and security/firewall configurations.

#### GCP Setup
In addition to AWS, GCP is also used as a cloud provider. Terraform provisions similar resources on GCP:
- `Google Compute Engine Instance`: Virtual machine to run the web application.
- `Static IP`: A fixed IP address allocated for the instance.
- `Firewall`: A GCP firewall rule allowing HTTP/HTTPS traffic.
Example GCP-specific Terraform code for provisioning the VM and static IP:
```
resource "google_compute_address" "static_ip" {
  name   = "my-web-ip"
  region = "us-central1"
}

resource "google_compute_instance" "my_instance" {
  name          = "cloud-1"
  machine_type  = "e2-medium"
  zone          = "us-central1-a"
  ...
}

resource "google_compute_firewall" "allow-http-https" {
  name    = "allow-http-https"
  network = "default"
  ...
}
```

#### Auto-Connection Setup (Elastic IP and Static IP)
- `GCP Static IP`: On GCP, a Static IP is allocated using the google_compute_address resource, ensuring that the VM always has the same public IP.
The IP addresses from both providers are used to ensure that the instance is always accessible, regardless of instance restarts.

Example for GCP:
```
resource "google_compute_address" "static_ip" {
  name   = "inception"
  region = "us-central1"
}
```

## Configuration Management with Ansible
### Step 2: Configuring the Instance with Ansible
Once the infrastructure is provisioned, Ansible is used to configure the instance. This involves several tasks, including:
1. `Installing Dependencies`: Install Docker, Docker Compose, and other necessary utilities.
2. `Folder Structure`: Set up the required folder structure for the application (e.g., /home/ubuntu/cloud-1).
3. `Copying Files`: The [Inception](https://github.com/DavidOhanyan/Docker-Inception) repository (which contains the necessary configurations for WordPress) is copied to the instance.
4. `Running Services`: Ansible is used to start the necessary services in containers, including WordPress, MySQL, and PHPMyAdmin.
Ansible plays are organized into roles and tasks for modularity and maintainability.

##### Roles
Roles are used to organize tasks into reusable units of functionality. The project utilizes the following main roles:
1. `Setup Role`: Configures the instance, installing necessary dependencies such as Docker and Docker Compose.
2. `Folder Structure Role`: Ensures that the required directories for the WordPress site and database are created.
3. `Run Services Role`: Runs the necessary commands to start Docker containers for each service (WordPress, MySQL, PHPMyAdmin).

The `main_playbook.yml` orchestrates the execution of all roles:
```
- name: Setup Instance
  import_playbook: ./playbooks/setup.yml
  tags: setup

- name: Set up folder structure
  import_playbook: ./playbooks/folder_structure.yml
  tags: folder_structure

- name: Run services
  import_playbook: ./playbooks/run.yml
  tags: run
```
The `main.yml` file defines the playbooks and roles that Ansible should run. It ensures that the setup process is completed in an organized manner:
```
- name: Setup YC Instance
  hosts: all
  become: true
  roles:
    - setup
  tags: setup
```
This structure ensures that the deployment steps are modular and easily extendable.

## Application Deployment
### Step 3: Running the Application
Once the configuration is complete, Ansible continues to run the necessary services:
- `Running WordPress`: The WordPress container is launched and configured to connect to the database.
- `Running MySQL`: A MySQL container is deployed to manage the WordPress site's data.
- `Running PHPMyAdmin`: PHPMyAdmin is deployed for managing the MySQL database.

## Security and Access
### Step 4: Securing the Application
The security of the deployment is ensured by:
- `Firewall Rules`: Only HTTP and HTTPS traffic (ports 80 and 443) are allowed through the firewall, limiting access to the services.
- `Restricting Database Access`: The MySQL database is not exposed to the internet directly. Instead, it communicates internally with the WordPress container.
- `SSL/TLS (Optional)`: SSL certificates can be configured for HTTPS access, securing the communication between users and the server.

## Testing and Scaling
### Step 5: Testing
Once the application is deployed, it’s important to test:
- `WordPress Site`: Ensure that the WordPress site is accessible via the assigned static IP or Elastic IP.
- `PHPMyAdmin`: Verify access to PHPMyAdmin for database management.
- `Persistence`: Confirm that data persists across container restarts by restarting the server and checking that the site and data are still intact.

### Step 6: Scaling (Optional)
The application can be scaled by:
- `Provisioning Additional Instances`: Terraform can be used to create additional cloud instances, either for load balancing or redundancy.
- `Configuring Load Balancing`: A load balancer can be set up to distribute traffic across multiple instances.
- `Database Replication`: Ensure the MySQL database is replicated across instances to maintain data consistency.

## Conclusion
The Cloud-1 project provides an automated and scalable solution for deploying a WordPress website using Docker containers on AWS and GCP. By leveraging Terraform and Ansible, the entire deployment process is automated, making it easier to replicate and manage the infrastructure.

This solution ensures security, persistence, and scalability, making it suitable for a production environment.

## Sources
### Collaborative project:
This project was collaboratively developed by `dohanyan` and `arakhurs`. The original project was based on GCP, and we worked together to extend its scope and deploy it on AWS as well. The repository contains the work done by both contributors.

### Inception Project:
The "Inception" project served as the main inspiration and base for this deployment automation. The challenge was to replicate and automate the deployment of a WordPress site with containers for each service while ensuring that each process runs in a separate container. You can find more details on the original [Inception](https://github.com/DavidOhanyan/Docker-Inception)

### Learning materials
- [Terraform](https://developer.hashicorp.com/terraform/docs)
- [Ansible](https://docs.ansible.com/)
- [AWS](https://docs.aws.amazon.com/)
- [GCP](https://cloud.google.com/docs?_gl=1*7j7fko*_up*MQ..&gclid=CjwKCAiAzPy8BhBoEiwAbnM9O9xtvXdnBqTRPFr4LhlWNYOQv2TPg8G4AabYHnmkNQLfK--lMIpX9RoCMjcQAvD_BwE&gclsrc=aw.ds)
- [Other_YT](https://www.youtube.com/@ADV-IT)
