//////////////////////////////
// CREATE SYNAPSE WORKSPACE //
//////////////////////////////

//
// PARAMETERS
//
param workspaceName string
param location string
param resourceTags object
param storageAccountName string
param firewallRuleName1 string
param firewallAddressRange1 object
param firewallRuleName2 string
param firewallAddressRange2 object
param sqlAdminUsername string
@secure()
param sqlAdminPassword string

//
// VARIABLES
//
var storageAccountSuffix = environment().suffixes.storage
var storageAccountAddress = 'https://${storageAccountName}.dfs.${storageAccountSuffix}'

//
// RESOURCES
//
resource workspace 'Microsoft.Synapse/workspaces@2021-04-01-preview' = {
  name: workspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: resourceTags
  properties: {
    defaultDataLakeStorage: {
      accountUrl: storageAccountAddress
      filesystem: 'analytics'
    }
    sqlAdministratorLogin: sqlAdminUsername
    sqlAdministratorLoginPassword: sqlAdminPassword
  }
}

resource firewallRule1 'Microsoft.Synapse/workspaces/firewallRules@2021-04-01-preview' = {
  name: firewallRuleName1
  parent: workspace
  properties: firewallAddressRange1
}

resource firewallRule2 'Microsoft.Synapse/workspaces/firewallRules@2021-04-01-preview' = {
  name: firewallRuleName2
  parent: workspace
  properties: firewallAddressRange2
}

//
// MODULE OUTPUT
//
output managedIdentityId string = workspace.identity.principalId
