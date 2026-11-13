//
//  AJ_s_Quoting_App_V2_BetaApp.swift
//  AJ's Quoting App V2 Beta
//
//  Created by Alex Schmidt on 2025-07-17.
//

import SwiftUI
import SwiftData

@main
struct AJ_s_Quoting_App_V2_BetaApp: App {
    @AppStorage("userName") private var userName = ""

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if userName.isEmpty {
                WelcomeView()
            } else {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
