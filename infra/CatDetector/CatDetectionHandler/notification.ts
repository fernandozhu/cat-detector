import {
  NotificationHubsClient,
  createAppleNotification,
} from "@azure/notification-hubs";
import * as NodeCache from "node-cache";
import {
  notificationHubConnectionKey,
  notificationHubName,
} from "../utils/constants";
import { getSecret } from "../utils/keyVault";

export class NotificationClient {
  private readonly _alertSound = "bingbong.aiff";
  private _client: NotificationHubsClient;
  private _cache: NodeCache;

  constructor(cache: NodeCache) {
    this._cache = cache;
  }

  public async sendPushNotification(message: string) {
    this.initialiseClient();

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

  private async initialiseClient() {
    if (this._client) {
      return;
    }

    const connectionString = await getSecret(
      notificationHubConnectionKey,
      this._cache
    );

    this._client = new NotificationHubsClient(
      connectionString,
      notificationHubName
    );
  }
}
