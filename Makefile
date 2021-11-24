.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo 
	@echo Delpoing EC2 instances with ansible
	@echo
	@fgrep "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*## / - /'
	@echo

.PHONY: lint-yaml 
lint-yaml: ## Perform YAML lint
	yamllint . --no-warnings
	
# ansible-lint doesn't work because of ansible-vault, so all what I can do is just a syntax check

#.PHONY: lint-ansible
#lint-ansible:
#	ansible-lint **/*.yml

.PHONY: ansible-check 
check: ## Syntax check
	ansible-playbook graduation_project.yaml --syntax-check --ask-vault-pass

.PHONY: start 
start: ## Start project
	ansible-playbook graduation_project.yaml --ask-vault-pass --key-file my-key.pem

