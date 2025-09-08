//
//  SubscriptionTrackerApp.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import SwiftUI

@main
struct SubscriptionTrackerApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
