param resourceTags object
param firewallRule1 object // for blog storage
param firewallRule2 object
param firewallRule3 object
param storageAccountName string
param synapseWorkspaceName string
param firewallRuleName1 string // for synapse workspace
param firewallAddressRange1 object
param firewallRuleName2 string
param firewallAddressRange2 object
param firewallRuleName3 string
param firewallAddressRange3 object
param sqlAdminUsername string
param needRoleAssignment bool = true
param stgBlobContribRoleId string
param stgRoleNameGuid string = guid(resourceGroup().id, stgBlobContribRoleId)
param keyVaultContribRoleId string
param keyVaultName string
param keyVaultResourceGroup string
param keyVaultRoleNameGuid string = guid(resourceGroup().id, keyVaultContribRoleId)

var roleDefinitionId_stg = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${stgBlobContribRoleId}'
var roleDefinitionId_vault = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${keyVaultContribRoleId}'

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
    firewallRuleName3: firewallRuleName3
    firewallAddressRange3: firewallAddressRange3
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
    firewallRule3: firewallRule3
  }
}

module kvAccess 'kv_access.bicep' = if (needRoleAssignment) {
  name: 'kvRoleAssignment'
  scope: resourceGroup(keyVaultResourceGroup)
  params: {
    keyVaultRoleNameGuid: keyVaultRoleNameGuid
    roleDefinitionId_vault: roleDefinitionId_vault
    synapsePrincipalId: synapseModule.outputs.managedIdentityId
  }
}

resource stgRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (needRoleAssignment) {
  name: stgRoleNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId_stg
    principalId: synapseModule.outputs.managedIdentityId
  }
}
