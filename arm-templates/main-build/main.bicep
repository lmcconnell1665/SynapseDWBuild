param resourceTags object
param firewallRules object // for blog storage
param storageAccountName string
param synapseWorkspaceName string
param firewallRuleName string
param firewallAddressRange object // for synapse workspace
param sqlAdminUsername string
param roleNameGuid string = newGuid()
param stgBlobContribRoleId string
var roleDefinitionId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${stgBlobContribRoleId}'

module synapseModule 'synapse.bicep' = {
  name: 'synapseDeploy'
  params: {
    workspaceName: synapseWorkspaceName
    location: resourceGroup().location
    resourceTags: resourceTags
    storageAccountName: storageAccountName
    firewallRuleName: firewallRuleName
    firewallAddressRange: firewallAddressRange
    sqlAdminUsername: sqlAdminUsername
  }
}

module stgModule 'storage.bicep' = {
  name: 'storageDeploy'
  params: {
    storageAccountName: storageAccountName
    location: resourceGroup().location
    resourceTags: resourceTags
    firewallRules: firewallRules
  }
}

resource stgRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: synapseModule.outputs.managedIdentityId
  }
}
