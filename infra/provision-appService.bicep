param name string
param location string = resourceGroup().location

@secure()
param ghRepo string
param ghToken string

module asplan './appServicePlan.bicep' = {
  name: 'AppServicePlan_AppService'
  params: {
    name: '${name}-api'
    location: location
  }
}

module appsvc './appService.bicep' = {
  name: 'AppService_AppService'
  params: {
    name: '${name}-api'
    location: location
    appServicePlanId: asplan.outputs.id
    ghRepo:ghRepo
    ghToken:ghToken
  }
}

output id string = appsvc.outputs.id
output name string = appsvc.outputs.name
