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
	ansible-playbook role_for_ecs.yaml role_for_rds.yaml  --syntax-check --vault-password-file ~/.vault_pass.txt

.PHONY: terraform-check
terraform-check: ## Check whether the configuration is valid
	terraform validate

.PHONY: init
init: ## Initialize terraform and prepare directory
	terraform init

# .PHONY: plan
# plan: ## Get plan of the project
# 	terraform plan -out=${PWD}/.terraform/terraform.plan

.PHONY: apply
create: ## Set up infrastracture
	terraform apply -auto-approve 
# ${PWD}/.terraform/terraform.plan

.PHONY: list
list: ## Show a resource in the state
	terraform state list

.PHONY: show
show: ## Show the current state or a saved plan
	terraform show 

.PHONY: destroy
destroy: ## Destroy all 
	terraform destroy

