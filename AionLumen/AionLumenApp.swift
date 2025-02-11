//
//  AionLumenApp.swift
//  AionLumen
//
//  Created by Aoin Digital on 22/01/2025.
//

import SwiftUI
import SwiftData
import Intents
import AppIntents

@main
struct AionLumenApp: App {
     
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var resetOnLaunch = true
    
    //MARK: Custom Intents
    struct AionLumenIntent: AppIntentsExtension {
        static var start: [any AppIntent] {
            [StartRecordingIntent()]
        }
    }
    
    //MARK: Swift Data Schema
    ///Schema: v0.1
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecordingModel.self,
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
            RecorderView()
        }
        .modelContainer(sharedModelContainer)
    }
}
