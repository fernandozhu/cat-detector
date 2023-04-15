
## Installation
Install the Core Tools package

```bash
brew tap azure/functions
brew install azure-functions-core-tools@4
# if upgrading on a machine that has 2.x or 3.x installed:
brew link --overwrite azure-functions-core-tools@4
```

Folder structure
CV: Computer Vision

Infra: Infrastructure as code


Running Azure Function locally
1. Navigate to the CatDetector Azure Function folder
2. Run `func start` to run the Azure Function locally


# Generate Apple Push Notification Service (APN) certificate
https://learn.microsoft.com/en-us/azure/notification-hubs/ios-sdk-get-started
# Set up Azure Notification Hub APNS settings with Token based authentication

Example iOS notification code with swift UI:
https://github.com/Azure/azure-notificationhubs-ios/tree/main/SampleNHAppSwiftUI
https://github.com/Azure/azure-notificationhubs-ios/tree/main/SampleNHAppSwiftUI2 (iOS 14)