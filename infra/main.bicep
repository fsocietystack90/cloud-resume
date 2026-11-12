// Settings you can change in one place
param location string = resourceGroup().location
param cosmosAccountName string = 'cosmos-jesusmaria-resume'

// The Cosmos DB account
resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' = {
  name: cosmosAccountName
  location: location
  kind: 'GlobalDocumentDB'
  tags: {                                    // NEW
    defaultExperience: 'Core (SQL)'          // NEW
    'hidden-workload-type': 'Learning'       // NEW
  }                                          // NEW
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: true
    enableAutomaticFailover: true            // NEW
    minimalTlsVersion: 'Tls12'               // NEW
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    capacity: {
      totalThroughputLimit: 1000
    }
  }
}

// The database inside the account
resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-11-15' = {
  parent: cosmosAccount
  name: 'resume-db'
  properties: {
    resource: {
      id: 'resume-db'
    }
  }
}

// The container inside the database
resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-11-15' = {
  parent: database
  name: 'counter'
  properties: {
    resource: {
      id: 'counter'
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
        version: 2                           // NEW
      }
    }
    options: {
      throughput: 400
    }
  }
}
