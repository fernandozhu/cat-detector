import { AzureFunction, Context } from "@azure/functions";
import { EventGridEvent } from "@azure/eventgrid";
import { StorageBlobEventData } from "../models/event";
import { CatDetectionRecord } from "../models/record";
import { NotificationClient } from "./notification";

const eventGridTrigger: AzureFunction = async function (
  context: Context,
  eventGridEvent: EventGridEvent<StorageBlobEventData>
): Promise<void> {
  const notificationClient = new NotificationClient();
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
