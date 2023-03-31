//
//  CatDetectorApp.swift
//  CatDetector
//
//  Created by Fernando Zhu on 31/03/23.
//

import SwiftUI

@main
struct CatDetectorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
