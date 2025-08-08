@description('Location for all resources')
param location string = 'Central India'

@description('Name of the resource group')
param resourceGroupName string = 'rg-secure-nodejs-app'

@description('App Service Plan name')
param appServicePlanName string = 'nodejsAppServicePlan'

@description('Web App name')
param webAppName string = 'my-secure-nodejs-app'

// Optional: Create Resource Group (only if deployed at subscription scope)
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!empty(resourceGroupName)) {
  name: resourceGroupName
  location: location
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'app'
  properties: {
    reserved: true // For Linux
  }
}

// Web App (App Service)
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    clientCertEnabled: true
  }
}
