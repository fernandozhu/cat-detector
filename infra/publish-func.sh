#!/bin/bash
source ./variables.sh

pushd ./$funcCatDetector
# Deploy Azure Function code to Function App
npm run build
func azure functionapp publish $funcAppName
popd 