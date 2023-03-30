#!/bin/bash
# Create and initialise Azure Function
source ./variables.sh

cd ../func-app
mkdir $funcCatDetector
cd $funcCatDetector
func init --worker-runtime dotnet
func new --template "Http Trigger" --name CatDetectionHandler
