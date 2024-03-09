@minLength(3)
param appName string
param location string

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
