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
	az login --tenant lbmc.onmicrosoft.com

# Create a new dev resource group
rg:
	az group create \
	--location southcentralus \
	--name rg-dev-dw-2 \
	--tags Environment="Dev" Project="Data Warehouse"

# Spin up dev resources
spinup:
	az deployment group create \
	--resource-group rg-dev-dw-2 \
	--template-file ./arm-templates/main-build/main.bicep \
	--parameters ./arm-templates/main-build/dev_parameters.json

# Delete the dev resource group
spindown:
	az group delete -n rg-dev-dw-2