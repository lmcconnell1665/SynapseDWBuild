# Create virtual environment
# use `source ~/.synapsedwbuild/bin/activate` to activate
setup:
	python3 -m venv ~/.synapsedwbuild

# Install project dependencies
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

# Decompile ARM to Bicep
decompile:
	az bicep decompile --file arm-templates/synapse-workspace/template.json

# Login to Azure
login:
	az login --tenant lbmc.onmicrosoft.com

# Spin up dev resources
spinup:
	az deployment group create \
	--resource-group rg-dev-dw \
	--template-file ./arm-templates/main-build/main.bicep \
	--parameters ./arm-templates/main-build/parameters.json
