#!/bin/bash

source ./variables.sh


if [ ! -d "../func-app/$funcCatDetector" ]
then
    source ./func-init.sh
fi

# Switch subscription
az account set --subscription $subscription
az group create --name $resourceGroupName --location $location
az deployment group create --resource-group $resourceGroupName --template-file $templateFile  --parameters funcAppName=$funcAppName

source ./func-publish.sh