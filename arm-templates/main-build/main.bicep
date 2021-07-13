param resourceTags object
param firewallRules object // for blog storage
param storageAccountName string
param synapseWorkspaceName string
param firewallRuleName string
param firewallAddressRange object // for synapse workspace
param sqlAdminUsername string
param roleNameGuid string = guid(resourceGroup().id)
param stgBlobContribRoleId string
param keyVaultName string
param keyVaultResourceGroup string

var roleDefinitionId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${stgBlobContribRoleId}'

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup(subscription().subscriptionId, keyVaultResourceGroup)
}

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
    sqlAdminPassword: kv.getSecret('healthcare-analytics-sql-pw')
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
