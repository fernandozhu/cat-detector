param location string = resourceGroup().location
param funcAppName string

resource imageStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'stcatdetector'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource funcAppStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'stcatdetectorfuncmeta'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-cat-detector'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource funcApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'func-cat-detector'
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcAppStorage.name};AccountKey=${funcAppStorage.listKeys().keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: funcAppName
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcAppStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcAppStorage.listKeys().keys[0].value}'
        }
      ]
    }
  }
}

resource notificationNamespace 'Microsoft.NotificationHubs/namespaces@2017-04-01' = {
  name: 'ntfns-cat-detector'
  location: location
  sku: {
    name: 'Free'
  }
}

resource notificationHub 'Microsoft.NotificationHubs/namespaces/notificationHubs@2017-04-01' = {
  name: 'ntf-cat-detector'
  location: location
  parent: notificationNamespace
  properties: {
    // Add Apple Push Notification Service (APNS) configurations here or
    // configue it in Azure Portal later on
  }
}