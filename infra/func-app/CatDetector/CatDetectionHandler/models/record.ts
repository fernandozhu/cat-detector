import { EventGridEvent } from "@azure/eventgrid";
import { StorageBlobEventData } from "./event";

interface ICatDetectionRecord {
  id: string;
  imageUrl: string;
  date: string;
  time: string;
  isRead: boolean;
}

export class CatDetectionRecord implements ICatDetectionRecord {
  private _id: string;
  private _imageUrl: string;
  private _date: string;
  private _time: string;
  private _isRead: boolean = false;

  public get id(): string {
    return this._id;
  }

  public get imageUrl(): string {
    return this._imageUrl;
  }

  public get date(): string {
    return this._date;
  }

  public get time(): string {
    return this._time;
  }

  public get isRead(): boolean {
    return this._isRead;
  }

  constructor(event: EventGridEvent<StorageBlobEventData>) {
    this._imageUrl = event.data.url;
    ({ date: this._date, time: this._time } = this.toLocalDateTime(
      event.eventTime
    ));
  }

  public toJSON(): ICatDetectionRecord {
    return {
      id: this.id,
      imageUrl: this.imageUrl,
      date: this.date,
      time: this.time,
      isRead: this.isRead,
    };
  }

  /**
   * Convert UTC date to NZ local date and time (24 hours) string
   * @param utcDate
   * @returns
   */
  private toLocalDateTime(utcDate: string | Date): {
    date: string;
    time: string;
  } {
    if (typeof utcDate === "string") {
      utcDate = new Date(utcDate);
    }

    let [date, time] = utcDate
      .toLocaleString("en-NZ", {
        timeZone: "Pacific/Auckland",
        hour12: false,
      })
      .split(", ");

    const [day, month, year] = date.split("/");
    date = [year, month, day].join("-");

    return {
      date,
      time,
    };
  }
}
