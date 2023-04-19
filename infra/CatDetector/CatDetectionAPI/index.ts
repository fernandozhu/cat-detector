import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { CosmosClient } from "@azure/cosmos";
import * as NodeCache from "node-cache";
import { getSecret } from "../utils/keyVault";
import {
  cosmosDbConnectionKey,
  cosmosDbContainerName,
  cosmosDbName,
} from "../utils/constants";

const cache = new NodeCache();

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<void> {
  const connectionString = await getSecret(cosmosDbConnectionKey, cache);
  const cosmosClient = new CosmosClient(connectionString);
  const container = cosmosClient
    .database(cosmosDbName)
    .container(cosmosDbContainerName);

  const records = await container.items.query("SELECT * FROM C").fetchAll();

  context.res = {
    body: {
      records: records.resources,
      hasMoreResults: records.hasMoreResults,
    },
  };
};

export default httpTrigger;
