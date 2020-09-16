export PATH := /snap/bin:$(PATH)

# TARGETS
pull-classic-snap: ## Pull the classic slurm snap from github
	@wget https://github.com/omnivector-solutions/snap-slurm/releases/download/20.02/slurm_20.02.1_amd64_classic.snap -O slurm.resource

pull-charms-from-edge: clean ## pull charms from edge s3
	@./scripts/pull_charms.sh edge


pull-snap-if-not-exists: ## If the snap.resource doesn't exist, pull it down from github
	@if ! [[ -f slurm.resource ]]; then\
	    wget https://github.com/omnivector-solutions/snap-slurm/releases/download/20.02/slurm_20.02.1_amd64_classic.snap -O slurm.resource;\
	fi

deploy-bionic-bundle-on-aws: pull-snap-if-not-exists ## Deploy bionic bundle on aws
	@juju deploy ./bundles/slurm-core-bionic-aws/bundle.yaml

deploy-focal-bundle-on-aws: pull-snap-if-not-exists ## Deploy focal bundle on aws
	@juju deploy ./bundles/slurm-core-focal-aws/bundle.yaml

deploy-centos7-bundle-on-aws: pull-snap-if-not-exists ## Deploy centos7 bundle on aws
	@juju deploy ./bundles/slurm-core-centos7-aws/bundle.yaml

deploy-centos8-bundle-on-aws: pull-snap-if-not-exists ## Deploy centos8 bundle on aws
	@juju deploy ./bundles/slurm-core-centos8-aws/bundle.yaml


test-slurmrestd-api-returns-200: # Make a request slurmrestd api endpoint to verify operational status
	@scripts/verify_slurmrestd.sh

# Display target comments in 'make help'
help: 
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# SETTINGS
# Use one shell for all commands in a target recipe
.ONESHELL:
# Set default goal
.DEFAULT_GOAL := help
# Use bash shell in Make instead of sh 
SHELL := /bin/bash
