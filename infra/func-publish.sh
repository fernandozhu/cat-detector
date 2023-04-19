#!/bin/bash
source ./variables.sh

cd ../$funcCatDetector
# Deploy Azure Function code to Function App
npm run build
func azure functionapp publish $funcAppName