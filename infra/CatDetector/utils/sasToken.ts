import { ContainerClient, ContainerSASPermissions } from "@azure/storage-blob";
import * as NodeCache from "node-cache";
import { getSecret, hasSecret, setSecret } from "./keyVault";
import { storageAccountConnectionKey, storageAccountSasKey } from "./constants";

export const getSasToken = async (cache: NodeCache) => {
  const hasSasToken = await hasSecret(storageAccountSasKey);

  if (hasSasToken) {
    return await getSecret(storageAccountSasKey, cache);
  }

  const connection = await getSecret(storageAccountConnectionKey, cache);

  const expireDate = new Date();
  expireDate.setFullYear(expireDate.getFullYear() + 1); // One year from now

  const client = new ContainerClient(connection, "images");
  const sasUrl = await client.generateSasUrl({
    permissions: ContainerSASPermissions.parse("r"),
    expiresOn: expireDate,
  });
  await setSecret(storageAccountSasKey, sasUrl, cache);
};
