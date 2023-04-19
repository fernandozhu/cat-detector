import { AzureFunction, Context } from "@azure/functions";
import { EventGridEvent } from "@azure/eventgrid";
import * as NodeCache from "node-cache";
import { StorageBlobEventData } from "../models/event";
import { CatDetectionRecord } from "../models/record";
import { NotificationClient } from "./notification";

const cache = new NodeCache({
  stdTTL: 3600, // Cache expires after 1 hour
});

const eventGridTrigger: AzureFunction = async function (
  context: Context,
  eventGridEvent: EventGridEvent<StorageBlobEventData>
): Promise<void> {
  const notificationClient = new NotificationClient(cache);
  const record = new CatDetectionRecord(eventGridEvent);

  try {
    context.bindings.outputDocument = JSON.stringify(record.toJSON());
    await notificationClient.sendPushNotification(
      "Meow meow, a 🐱 is detected"
    );
  } catch (err) {
    context.log(err);
  }
};

export default eventGridTrigger;
