param resourceTags object
param firewallRule1 object // for blog storage
param firewallRule2 object
param storageAccountName string
param synapseWorkspaceName string
param firewallRuleName1 string // for synapse workspace
param firewallAddressRange1 object
param firewallRuleName2 string
param firewallAddressRange2 object
param sqlAdminUsername string
param roleNameGuid string = guid(subscription().id)
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
    firewallRuleName1: firewallRuleName1
    firewallAddressRange1: firewallAddressRange1
    firewallRuleName2: firewallRuleName2
    firewallAddressRange2: firewallAddressRange2
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
    firewallRule1: firewallRule1
    firewallRule2: firewallRule2
  }
}

resource stgRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: synapseModule.outputs.managedIdentityId
  }
}
