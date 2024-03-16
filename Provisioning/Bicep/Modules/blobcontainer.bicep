@minLength(3)
param appName string
param location string
param groupPrincipalId string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${appName}sa'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'BlobStorage'

  properties: {
    accessTier: 'Cool'
    allowBlobPublicAccess: true
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
  }
}

@description('This is the built-in Storage Blob Data Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  scope: subscription()
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: sa
  name: guid(sa.id, groupPrincipalId, contributorRoleDefinition.id)
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: groupPrincipalId
    principalType: 'Group'
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: sa
}

resource saContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: 'container'
  parent: blobServices
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountid string = sa.id
