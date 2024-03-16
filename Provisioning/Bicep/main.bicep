@minLength(3)
param appName string
param location string
var groupPrincipalId = 'c116e555-ede2-4efc-a178-d74d71bba6c4'

module blobContainer 'Modules/blobcontainer.bicep' = {
  name: 'blobContainer'
  params: {
    appName: appName
    location: location
    groupPrincipalId: groupPrincipalId
  }
}

module imageProcessorfunction 'Modules/azfunction.bicep' = {
  name: 'imageProcessorfunction'
  params: {
    appName: '${appName}-imageprocessor'
    storageAccountName: '${appName}functionsa'
    location: location
  }
}

module eventGrid 'Modules/eventgrid.bicep' = {
  name: 'eventGrid'
  params: {
    appName: appName
    blobStorageAccountId: blobContainer.outputs.storageAccountid
    location: location
    endpoint: imageProcessorfunction.outputs.functionEndpoint
  }
}
