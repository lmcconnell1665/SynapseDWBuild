////////////////////////////
// CREATE STORAGE ACCOUNT //
////////////////////////////

//
// PARAMETERS
//
@description('the name given to the ADLS Gen2 storage account')
param storageAccountName string

@description('the location of the resource group')
param location string

@description('the tags to associate with the resources')
param resourceTags object

@description('The IP addresses to allow access to the storage account')
param firewallRule1 object
param firewallRule2 object

//
// VARIABLES
//
var blobServiceName = 'default'
var sqlLogsContainerName = 'sqllogs'
var bronzeContainerName = 'bronze'
var silverContainerName = 'silver'
var goldContainerName = 'gold'
var etlControlContainerName = 'etlcontrol'

//
// RESOURCES
//
resource stgAcct 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_RAGRS'
  }
  tags: resourceTags
  properties: {
    isHnsEnabled: true
    accessTier: 'Hot'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: [
        firewallRule1
        firewallRule2
      ]
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  name: blobServiceName
  parent: stgAcct
}

resource sqlLogsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: sqlLogsContainerName
  parent: blobService
}

resource bronzeContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: bronzeContainerName
  parent: blobService
}

resource silverContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: silverContainerName
  parent: blobService
}

resource goldContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: goldContainerName
  parent: blobService
}

resource etlControlContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: etlControlContainerName
  parent: blobService
}

//
// MODULE OUTPUT
//
output storageId string = stgAcct.id
