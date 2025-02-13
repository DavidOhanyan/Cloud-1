.DEFAULT_GOAL := help

docker:
	@echo "IMPORTANT:"
	@echo "You must add the following parameters to the group_vars file to properly configure Docker installation."
	@echo "These parameters are required for setting up the Docker repository with a valid GPG key."
	@echo "docker_repo:"
	@echo "  https://download.docker.com/linux/ubuntu"
	@echo "GPG_key:"
	@echo "  https://download.docker.com/linux/ubuntu/gpg"
	@echo "\nDefault values:\n"
	@echo "docker_repo: https://download.docker.com/linux/ubuntu"
	@echo "GPG_key: https://download.docker.com/linux/ubuntu/gpg"

help: docker
	@echo "❌ Error: please specify a command!"
	@echo "   Available commands:"
	@echo "   make init       - Initialize Terraform"
	@echo "   make apply      - Apply Terraform configuration"
	@echo "   make upgrade    - Upgrade Terraform configuration"
	@echo "   make destroy    - Destroy infrastructure with Terraform"
	@echo "   make up         - Ansible Lifting infrastructure"
	@echo "   make down       - Run Ansible for cleanup"
	@echo "   make deep_down  - Run Ansible for deep cleanup with removal"
	@echo "	  make var	  - Adding docker instalation in ansible variables file"

init:
	terraform init 

plan:
	terraform plan

apply:
	terraform apply -auto-approve

upgrade:
	terraform apply -upgrade

destroy:
	terraform destroy -auto-approve

up:
	@ansible-playbook main.yaml

down:
	ansible-playbook playbooks/cleanup.yaml --extra-vars "action_type="

deep_down:
	ansible-playbook playbooks/cleanup.yaml --extra-vars "action_type=remove"

nginx:
	ansible-playbook manual.yaml --extra-vars "image=nginx"

mariadb:
	ansible-playbook manual.yaml --extra-vars "image=mariadb"

wordpress:
	ansible-playbook manual.yaml --extra-vars "image=wordpress"

phpadmin:
	ansible-playbook manual.yaml --extra-vars "image=phpmyadmin"

manual:
	ansible-playbook manual.yaml --extra-vars "image=up"

.PHONY: init plan apply upgrade destroy up down deep_down docker help nginx mariadb wordpress phpadmin manual

