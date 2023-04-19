import { SecretClient } from "@azure/keyvault-secrets";
import { DefaultAzureCredential } from "@azure/identity";
import * as NodeCache from "node-cache";
import { keyVaultUri } from "./constants";

export const getSecret = async (
  name: string,
  cache: NodeCache
): Promise<string> => {
  if (cache.has(name)) {
    return cache.get<string>(name);
  }

  const client = new SecretClient(keyVaultUri, new DefaultAzureCredential());
  const secret = await client.getSecret(name);
  cache.set(name, secret.value);
  return secret.value ?? "";
};
