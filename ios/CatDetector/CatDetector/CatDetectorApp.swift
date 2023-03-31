//
//  CatDetectorApp.swift
//  CatDetector
//
//  Created by Fernando Zhu on 31/03/23.
//

import SwiftUI
import WindowsAzureMessaging

let connectionString = "Endpoint=sb://ntfns-cat-detector.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=Hi0QCG7g5X57NIAGtKDhoRiE0P1+sQSnih24zebCfIM="
let hubName = "ntf-cat-detector"

@main
struct CatDetectorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear{
                    // MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
                    
                    if let path = Bundle.main.path(forResource: "Notification", ofType: "plist") {
                        if let propValues = NSDictionary(contentsOfFile: path) {
                            let connectionString = propValues["ConnectionString"] as? String
                            let hubName = propValues["HubName"] as? String
                            
                            print(hubName)
                        }
                    }
                }
        }
    }
}
