#!/bin/bash
source ./variables.sh

cd ../func-app/$funcCatDetector
# Deploy Azure Function code to Function App
func azure functionapp publish $funcAppName