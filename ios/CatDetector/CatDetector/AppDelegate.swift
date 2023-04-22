//
//  AppDelegate.swift
//  CatDetector
//
//  Created by Fernando Zhu on 2/04/23.
//

import UIKit
import WindowsAzureMessaging


class AppDelegate: NSObject, UIApplicationDelegate, MSNotificationHubDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        if let path = Bundle.main.path(forResource: "Notification", ofType: "plist") {
            if let propValues = NSDictionary(contentsOfFile: path) {
                let connectionString = propValues["NotificationConnection"] as? String ?? ""
                let hubName = propValues["HubName"] as? String ?? ""
                let apiUrl = propValues["ApiUrl"] as? String ?? ""

                if (!connectionString.isEmpty && !hubName.isEmpty) {
                    MSNotificationHub.setDelegate(self)
                    MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
                    
                    // May not need this
                    NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveCatNotification(notification:)), name: Notification.Name("CatNotificationReceived"), object: nil)
                }
            }
        }
        
        return true
    }
    
    func notificationHub(_ notificationHub: MSNotificationHub, didReceivePushNotification message: MSNotificationHubMessage) {
        let title = message.title ?? "NIL"
        let messageContent = message.body ?? "NIL"
        
        print("Title: \(title)\nMessage: \(messageContent)")
        
        let userInfo = ["message": message]
        NotificationCenter.default.post(name: NSNotification.Name("CatNotificationReceived"), object: nil, userInfo: userInfo)
    }
    
    @objc func didReceiveCatNotification(notification: Notification) {
//         May not need this
        print("didReceiveCatNotification")
    }
}
