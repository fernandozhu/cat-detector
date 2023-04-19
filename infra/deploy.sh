#!/bin/bash
set -e
source ./variables.sh

# Switch subscription
az account set --subscription $subscription
az group create --name $resourceGroupName --location $location
az deployment group create --resource-group $resourceGroupName --template-file $templateFile  --parameters funcAppName=$funcAppName

source ./func-publish.sh