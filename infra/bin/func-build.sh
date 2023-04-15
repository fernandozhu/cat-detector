###### [Imporant] ######
# MSDeploy doesn't work with local zip file, use func-publish.sh to deploy Azure Function instead
########################

#!/bin/bash
source ./variables.sh

pushd ../func-app/$funcCatDetector
dotnet publish --configuration Release --output bin/publish
pushd bin/publish/
zip -r ../../bin/CatDetector.zip ./*
popd
popd