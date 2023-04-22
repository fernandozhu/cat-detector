import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { CosmosClient } from "@azure/cosmos";
import * as NodeCache from "node-cache";
import { getSecret } from "../utils/keyVault";
import {
  cosmosDbConnectionKey,
  cosmosDbContainerName,
  cosmosDbName,
} from "../utils/constants";
import { getSasToken } from "../utils/sasToken";

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

  const sasUrl = await getSasToken(cache);
  const sasQuery = sasUrl.split("?")[1];

  const records = await container.items.query("SELECT * FROM C").fetchAll();

  // Attach SAS token to imageUrls so that iOS app can display images
  records.resources.forEach((r) => {
    r.imageUrl += `?${sasQuery}`;
  });

  context.res = {
    body: {
      records: records.resources,
      hasMoreResults: records.hasMoreResults,
    },
  };
};

export default httpTrigger;
