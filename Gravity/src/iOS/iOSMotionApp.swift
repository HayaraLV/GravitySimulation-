//
//  iOSMotionApp.swift
//  iOSMotion
//
//  Main Application Entry Point
//

import SwiftUI

@main
struct iOSMotionApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
