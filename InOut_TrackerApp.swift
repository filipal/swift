//
//  InOut_TrackerApp.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import SwiftUI

@main
struct InOut_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
