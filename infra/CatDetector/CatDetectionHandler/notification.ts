import {
  NotificationHubsClient,
  createAppleNotification,
} from "@azure/notification-hubs";
import { HUB_NAME, NOTIFICATION_CONNECTION } from "./env";

export class NotificationClient {
  private readonly _alertSound = "bingbong.aiff";
  private readonly _client: NotificationHubsClient;

  constructor() {
    this._client = new NotificationHubsClient(
      NOTIFICATION_CONNECTION,
      HUB_NAME
    );
  }

  public async sendPushNotification(message: string) {
    const messageBody = JSON.stringify({
      aps: { alert: message, sound: this._alertSound },
    });
    const notification = createAppleNotification({
      body: messageBody,
      headers: {
        "apns-priority": "10",
        "apns-push-type": "alert",
      },
    });

    await this._client.sendNotification(notification);
  }
}
