import { AzureFunction, Context } from "@azure/functions";
import { EventGridEvent } from "@azure/eventgrid";
import { StorageBlobEventData } from "./models/event";
import { CatDetectionRecord } from "./models/record";

const eventGridTrigger: AzureFunction = async function (
  context: Context,
  eventGridEvent: EventGridEvent<StorageBlobEventData>
): Promise<void> {
  context.log(typeof eventGridEvent);
  context.log(eventGridEvent);

  const record = new CatDetectionRecord(eventGridEvent);
  context.bindings.outputDocument = JSON.stringify(record.toJSON());
};

export default eventGridTrigger;
