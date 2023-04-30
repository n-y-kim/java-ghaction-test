targetScope = 'subscription'

param name string
param location string = 'Korea Central'
param ghRepo string
param ghToken string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${name}'
  location: location
}

module appsvc './provision-appService.bicep' = {
  name: 'AppService'
  scope: rg
  params: {
    name: name
    location: location
    ghRepo: ghRepo
    ghToken: ghToken
  }
}
