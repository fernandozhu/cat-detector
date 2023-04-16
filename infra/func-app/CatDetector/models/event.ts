import {
  StorageBlobCreatedEventData,
  StorageBlobDeletedEventData,
} from "@azure/eventgrid";

export type StorageBlobEventData =
  | StorageBlobCreatedEventData
  | StorageBlobDeletedEventData;
