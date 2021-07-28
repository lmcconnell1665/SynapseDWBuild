///////////////////////////////////
// GRANT SYNAPSE KEYVAULT ACCESS //
///////////////////////////////////

//
// PARAMETERS
//
param keyVaultRoleNameGuid string
param roleDefinitionId_vault string
param synapsePrincipalId string

//
// RESOURCES
//
resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: keyVaultRoleNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId_vault
    principalId: synapsePrincipalId
  }
}

