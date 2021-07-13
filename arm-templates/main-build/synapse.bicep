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
param firewallRuleName string
param firewallAddressRange object
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

resource firewallRule 'Microsoft.Synapse/workspaces/firewallRules@2021-04-01-preview' = {
  name: firewallRuleName
  parent: workspace
  properties: firewallAddressRange 
}

//
// MODULE OUTPUT
//
output managedIdentityId string = workspace.identity.principalId
