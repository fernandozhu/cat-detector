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

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: imageStorage
}

resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for containerName in [ 'images' ]: {
  name: containerName
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}]

resource noSqlAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' = {
  name: 'cosno-cat-detector'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
}

resource noSqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  parent: noSqlAccount
  name: 'cosmos-cat-detector'
  properties: {
    resource: {
      id: 'cosmos-cat-detector'
    }
  }
}

resource noSqlContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-11-15' = {
  parent: noSqlDatabase
  name: 'cat-detection'
  properties: {
    resource: {
      id: 'cat-detection'
      partitionKey: {
        paths: [
          '/date'
        ]
        kind: 'Hash'
      }
    }
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
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: funcAppName
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcAppStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${funcAppStorage.listKeys().keys[0].value}'
        }
        {
          // Better to store connection string into KeyVault
          name: 'CosmosDbConnectionString'
          value: noSqlAccount.listConnectionStrings().connectionStrings[0].connectionString
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

resource eventSubscription 'Microsoft.EventGrid/eventSubscriptions@2022-06-15' = {
  name: 'evgs-cat-detector'
  scope: imageStorage
  properties: {

    eventDeliverySchema: 'EventGridSchema'
    destination: {
      endpointType: 'AzureFunction'
      properties: {
        resourceId: resourceId('Microsoft.Web/sites/functions', funcAppName, 'CatDetectionHandler')
        maxEventsPerBatch: 1
        preferredBatchSizeInKilobytes: 64
      }
    }

    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
        'Microsoft.Storage.BlobDeleted'
      ]
      enableAdvancedFilteringOnArrays: true
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-cat-detector'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: '6125526c-d948-4839-b944-3d18efed5e27'
        tenantId: subscription().tenantId
        permissions: {
          keys: [ 'all' ]
          secrets: [ 'all' ]
        }
      }
      {
        objectId: funcApp.identity.principalId
        tenantId: subscription().tenantId
        permissions: {
          keys: [ 'list' ]
          secrets: [ 'list' ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource cosmosConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'cosmosdb-connection'
  parent: keyVault
  properties: {
    value: noSqlAccount.listConnectionStrings().connectionStrings[0].connectionString
  }
}

resource pushNotificationListenConnection 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'push-notification-connection-listen'
  parent: keyVault
  properties: {
    value: listKeys(resourceId('Microsoft.NotificationHubs/namespaces/notificationHubs/authorizationRules', notificationNamespace.name, notificationHub.name, 'DefaultListenSharedAccessSignature'), '2020-01-01-preview').primaryConnectionString
  }
}

resource pushNotificationFullAccessConnection 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'push-notification-connection-full'
  parent: keyVault
  properties: {
    value: listKeys(resourceId('Microsoft.NotificationHubs/namespaces/notificationHubs/authorizationRules', notificationNamespace.name, notificationHub.name, 'DefaultFullSharedAccessSignature'), '2020-01-01-preview').primaryConnectionString
  }
}

resource storageAccountAccessKey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'storage-account-access-key'
  parent: keyVault
  properties: {
    value: imageStorage.listKeys().keys[0].value // Better to use SAS instead
  }
}
