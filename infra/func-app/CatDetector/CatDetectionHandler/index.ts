import { AzureFunction, Context } from "@azure/functions";
import { EventGridEvent } from "@azure/eventgrid";
import {
  NotificationHubsClient,
  createAppleNotification,
} from "@azure/notification-hubs";
// import {  } from '@azure/notification-hubs'
import { StorageBlobEventData } from "./models/event";
import { CatDetectionRecord } from "./models/record";

const eventGridTrigger: AzureFunction = async function (
  context: Context,
  eventGridEvent: EventGridEvent<StorageBlobEventData>
): Promise<void> {
  context.log(typeof eventGridEvent);
  context.log(eventGridEvent);

  const record = new CatDetectionRecord(eventGridEvent);

  try {
    context.bindings.outputDocument = JSON.stringify(record.toJSON());
    //   context.bindings.outputNotification = JSON.stringify({
    //     aps: { alert: "Notification Hub test notification" },
    //   });

    const connectionString = "";

    const hubName = "ntf-cat-detector";

    const client = new NotificationHubsClient(connectionString, hubName);

    const messageBody = JSON.stringify({
      aps: { alert: "Meow, a 🐱 is detected", sound: "bellring.aiff" },
    });
    const notification = createAppleNotification({
      body: messageBody,
      headers: {
        "apns-priority": "10",
        "apns-push-type": "alert",
      },
    });

    context.log("*** SEND NOTIFICATION");
    client.sendNotification(notification);
  } catch (err) {
    context.log(err);
  }
};

export default eventGridTrigger;
