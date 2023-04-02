//
//  NotificationViewModel.swift
//  CatDetector
//
//  Created by Fernando Zhu on 2/04/23.
//

import Foundation

import WindowsAzureMessaging
import UIKit

//class NotificationViewModel: NSObject, ObservableObject, MSNotificationHubDelegate {
class NotificationViewModel: NSObject, ObservableObject {
    
    override init() {
        super.init()

//        if let path = Bundle.main.path(forResource: "Notification", ofType: "plist") {
//            if let propValues = NSDictionary(contentsOfFile: path) {
//                let connectionString = propValues["ConnectionString"] as? String ?? ""
//                let hubName = propValues["HubName"] as? String ?? ""
//
//                if (!connectionString.isEmpty && !hubName.isEmpty) {
//                    MSNotificationHub.setDelegate(self)
//                    MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
//                }
//            }
//        }
    }
    
//    func notificationHub(_ notificationHub: MSNotificationHub, didReceivePushNotification message: MSNotificationHubMessage) {
//        let title = message.title ?? "NIL"
//        let messageContent = message.body ?? "NIL"
//
//        print("Title: \(title)\nMessage: \(messageContent)")
//    }
}
