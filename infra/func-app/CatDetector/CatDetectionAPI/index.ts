import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { CosmosClient } from "@azure/cosmos";
import { CONTAINER_NAME, DATABASE_NAME, ENDPOINT, KEY } from "./env";

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<void> {
  const cosmosClient = new CosmosClient({ endpoint: ENDPOINT, key: KEY });
  const container = cosmosClient
    .database(DATABASE_NAME)
    .container(CONTAINER_NAME);

  const records = await container.items.query("SELECT * FROM C").fetchAll();

  context.res = {
    // status: 200, /* Defaults to 200 */
    body: {
      records: records.resources,
      hasMoreResults: records.hasMoreResults,
    },
  };
};

export default httpTrigger;
