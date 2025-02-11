//
//  AppDelegate.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application( _ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SpeechToTextEngine.shared.requestSpeechAuthorization()
        return true
    }
    
    
    private func registerDefaultShortcuts() {
        let activity = NSUserActivity(activityType: "com.aion.AionLumen")
        activity.title = "Start Aion Lumen"
        activity.suggestedInvocationPhrase = "Start Aion Lumen"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        UIApplication.shared.shortcutItems = [UIApplicationShortcutItem(type: activity.activityType, localizedTitle: activity.title!)]
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
}
