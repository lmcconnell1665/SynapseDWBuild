# Create virtual environment
# use `source ~/.synapsedwbuild/bin/activate` to activate
setup:
	python3 -m venv ~/.synapsedwbuild

# Install project dependencies
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

# Login to Azure
login:
	az login --tenant lbmc.onmicrosoft.com &&\
	az account set --subscription "Luke's Visual Studio Enterprise Subscription"

# Create a new dev resource group
rg:
	az group create \
	--location eastus \
	--name rg-dev-dw \
	--tags Environment="Dev" Project="Data Warehouse"

# Spin up dev resources
spinup:
	az deployment group create \
	--resource-group rg-dev-dw \
	--template-file ./arm-templates/main-build/main.bicep \
	--parameters ./arm-templates/main-build/dev_parameters.json

# Delete the dev resource group
spindown:
	az group delete -n rg-dev-dw-2