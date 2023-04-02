//
//  CatDetectorApp.swift
//  CatDetector
//
//  Created by Fernando Zhu on 31/03/23.
//

import SwiftUI
import WindowsAzureMessaging



@main
struct CatDetectorApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var notifictionViewModel = NotificationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notifictionViewModel)
                .onAppear{
                    // MSNotificationHub.start(connectionString: connectionString, hubName: hubName)
                    
                    
                }
        }
    }
}
