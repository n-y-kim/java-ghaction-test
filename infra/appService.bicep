param name string
param location string = resourceGroup().location

param appServicePlanId string

@secure()
param ghToken string
param ghRepo string

var asplan = {
  id: appServicePlanId
}

var apiApp = {
  name: 'appsvc-${name}'
  location: location
}

resource appsvc 'Microsoft.Web/sites@2022-03-01' = {
  name: apiApp.name
  location: apiApp.location
  kind: 'app,linux'
  properties: {
    serverFarmId: asplan.id
    httpsOnly: true
    reserved: true
    siteConfig: {
      linuxFxVersion: 'JAVA|17-java17'
      alwaysOn: true
      appSettings: [
        {
          name: 'WEBSITE_WEBDEPLOY_USE_SCM'
          value: 'true'
        }
      ]
    }
  }
}

resource appsvc_control 'Microsoft.Web/sites/sourcecontrols@2020-06-01' = {
  parent: appsvc
  name: 'web'
  properties: {
    repoUrl: ghRepo
    branch: 'main'
  }
}

var policies = [
  {
    name: 'scm'
    allow: true
  }
  {
    name: 'ftp'
    allow: false
  }
]


resource appsvcPolicies 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = [for policy in policies: {
  name: '${appsvc.name}/${policy.name}'
  location: apiApp.location
  properties: {
    allow: policy.allow
  }
}]

output id string = appsvc.id
output name string = appsvc.name
