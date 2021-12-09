.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo 
	@echo Delpoing ECS cluster and rds instance with terraform and ansible
	@echo
	@fgrep "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*## / - /'
	@echo

.PHONY: lint-yaml 
lint-yaml: ## Perform YAML lint
	yamllint . --no-warnings
	
.PHONY: ansible-check 
check: ## Ansible syntax check
	ansible-playbook ecs_graduation_project.yaml destroyer.yaml  --syntax-check --vault-password-file ~/.vault_pass.txt

.PHONY: terraform-check
	terraform validate

.PHONY: plan
plan: ## Get plan of the project
	terraform plan -out=${PWD}/.terraform/terraform.plan

.PHONY: apply
create: ## Set up infrastracture
	terraform apply ${PWD}/.terraform/terraform.plan

.PHONY: list
list: ## Show a resource in the state
	terraform state list

.PHONY: show
show: ## Show the current state or a saved plan
	terraform show 

.PHONY: destroy
destroy: ## Destroy all 
	terraform destroy

