# SynapseDWBuild
A project for setting up full CI/CD process for building a data warehouse using Azure Synapse Analytics. This repo contains the resources required to standup the Azure Synapse workspace (and other required infrastructure) in Azure as well as the artifacts used within the workspace. A developer would use these resources to standup resources and make changes before pushing to the DevOps repo which would trigger the test / prod build stages.
# Getting Started
Once you have cloned this repo to your (hopefully linux or unix based) local development machine, use the following steps to get started (note: Windows based development machines will be missing some features such as `make`)

## Create virtual environment
Run `make setup` to create a python virtual environment. Then run `source ~/.synapsedwbuild/bin/activate` to activate the virtual environment.

## Install dependencies
Run `make install` to install / update all packages from the `requirements.txt` file.

## Login to Azure via CLI
Run `make login` to activate the Azure authentication process. You may need to adjust the `--tenant` or `--subscription` in the Makefile.

## Create a dev resource group
Run `make rg` to create the dev resource group in Azure. You may need to adjust the `--name` as it must be unique in the subscription.

## Deploy dev resources to resource group
Run `make spinup` (with *your* resource group name specified as the `--resource-group`) to create the Azure resources using the `.bicep` files in the `iac/main-build` directory.

## Make changes or additions
Create a new working branch and make any needed changes to the resources/code artifacts. When you are finished make sure to commit your changes to your working branch.

## Destroy dev resources
**After your changes have been committed** run `make spindown` to destroy the dev resource groups.
