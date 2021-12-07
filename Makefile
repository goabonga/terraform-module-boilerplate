SHELL := /bin/bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

# Variables
TERRAFORM_DOCS_VERSION := 0.15.0
PROJECT_ROOT := $$(git rev-parse --show-toplevel)
BASIC_DIR := examples/basic

# Terraform
.PHONY: plan
plan: fmt ## plan basic
	terraform -chdir=$(BASIC_DIR) init
	terraform -chdir=$(BASIC_DIR) plan

.PHONY: apply
apply: ## apply basic
	terraform -chdir=$(BASIC_DIR) apply

.PHONY: destroy
destroy: ## destroy basic
	terraform -chdir=$(BASIC_DIR) destroy

.PHONY: fmt
fmt: ## format code
	cd $(PROJECT_ROOT) && terraform fmt -recursive
.PHONY: test
test: ## test module
	cd $(CURDIR)/test && go test -v -timeout 30m

# terraform-docs
.PHONY: docs
docs: ## generate docs
	@echo "$(CURDIR)"
	docker run --rm -v "$(CURDIR):/work" quay.io/terraform-docs/terraform-docs:$(TERRAFORM_DOCS_VERSION) /work

.PHONY: commit-docs
commit-docs: fmt docs ## generate docs and commit
	git add README.md
	git commit -m "regenerate documents by terraform-docs"

.PHONY: check-docs
check-docs: docs ## check docs
	test -z "$$(git status -s | tee /dev/stderr)"

# Release
.PHONY: bump-version
bump-version: ## bump version
	@current_version=$$(git tag --sort=-v:refname | head -1) && \
	echo "Current version: $${current_version}" && \
	read -rp "Input next version: " version && \
	branch=release-$${version} && \
	sed -i "" -e "s/$${current_version}/$${version}/" $(PROJECT_ROOT)/VERSION && \
	sed -i "" -e "s/$${current_version}/$${version}/" $(PROJECT_ROOT)/examples/**/main.tf && \
	$(MAKE) docs && \
	git checkout -b $${branch} && \
	git add . && \
	git commit -m "bump $${version}" && \
	git tag $${version} && \
	git push origin $${branch} $${version}

.PHONY: clean
clean: ## clean dir
	rm -rf "${BASIC_DIR}"/terraform.tfstate*
	rm -rf "${BASIC_DIR}"/.terraform*

# https://postd.cc/auto-documented-makefile/
.PHONY: help
help: ## show help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
