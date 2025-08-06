//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/6.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
