#r "Azure.Messaging.EventGrid"

using System;

using Azure.Messaging.EventGrid;


// public static void Run(EventGridEvent eventGridEvent, ILogger log)
// // public static void Run(EventGridEvent eventGridEvent, ILogger log)
// {
//     log.LogInformation(eventGridEvent.EventType.ToString());
//     log.LogInformation("***** Trigger is working");
// }

public static void Run(EventGridEvent eventGridEvent, out object outputDocument, ILogger log)
// public static void Run(EventGridEvent eventGridEvent, ILogger log)
{
    log.LogInformation("***** writing to db");
    outputDocument = new {
        id = "testid",
        date = "testdate"
    };
}

// Binding
// {
//   "type": "cosmosDB",
//   "name": "$return",
//   "databaseName": "cosmos-cat-detector",
//   "collectionName": "cat-detection",
//   "connectionStringSetting": "CosmosDbConnectionString",
//   "direction": "out",
//   "partitionKey": "/date"
// }

// public static object Run(EventGridEvent eventGridEvent, ILogger log)
// // public static void Run(EventGridEvent eventGridEvent, ILogger log)
// {
//     log.LogInformation(eventGridEvent.EventType.ToString());
//     log.LogInformation("***** Trying to write to Cosmos DB");

//     // Write out a single object
//     return new
//     {
//         id = "test-id",
//         date = "test-date"
//     };
// }

// public static async Task Run(EventGridEvent eventGridEvent, IAsyncCollector<object> objectOut, ILogger log)
// // public static void Run(EventGridEvent eventGridEvent, ILogger log)
// {
//     log.LogInformation(eventGridEvent.EventType.ToString());
//     log.LogInformation("***** Trying to write to Cosmos DB");

//     // Write out a single object
//     await objectOut.AddAsync(new
//     {
//         id = "test-id"
//     });
// }
