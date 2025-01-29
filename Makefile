
.DEFAULT_GOAL := help

help:
	@echo "❌ Error: please specify a command!"
	@echo "   Available commands:"
	@echo "   make init       - Initialize Terraform"
	@echo "   make apply      - Apply Terraform configuration"
	@echo "   make upgrade    - Upgrade Terraform configuration"
	@echo "   make destroy    - Destroy infrastructure with Terraform"
	@echo "   make up         - Ansible Lifting infrastructure"
	@echo "   make down       - Run Ansible for cleanup"
	@echo "   make deep_down  - Run Ansible for deep cleanup with removal"

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

.PHONY: init plan apply upgrade distroy up down deep_down

