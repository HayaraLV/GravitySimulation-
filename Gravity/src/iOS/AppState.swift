//
//  AppState.swift
//  iOSMotion
//
//  Application State Management
//

import Foundation
import Combine
import UIKit

/// Main application state
class AppState: ObservableObject {
    @Published var icons: [Icon] = []
    @Published var dockItems: [DockItem] = []
    @Published var currentMode: CurrentMode = .normal
    @Published var shakeCount: Int = 0
    @Published var lastShakeDate: Date = Date()
    @Published var debugMode: Bool = false
    @Published var physicsWorld: SKPhysicsWorld?
    
    private var shakeTimer: Timer?
    private var motionManager: CMMotionManager?
    
    init() {
        loadDefaultIcons()
        loadDefaultDockItems()
        setupMotionManager()
    }
    
    private func loadDefaultIcons() {
        let defaultIcons: [(label: String, iconName: String, iconType: String)] = [
            ("Photos", "photo", "photo"),
            ("Camera", "camera", "camera"),
            ("Weather", "cloud", "weather"),
            ("Maps", "map", "maps"),
            ("Clock", "clock", "clock"),
            ("Calendar", "calendar", "calendar"),
            ("Reminders", "checkmark.circle", "reminders"),
            ("Stocks", "chart.bar", "stocks"),
            ("News", "newspaper", "news"),
            ("Health", "heart", "health")
        ]
        
        icons = defaultIcons.map { Icon(
            id: UUID(),
            label: $0.0,
            iconName: $0.1,
            iconType: $0.2
        ) }
    }
    
    private func loadDefaultDockItems() {
        let defaultDockItems: [(iconName: String, label: String)] = [
            ("phone", "Phone"),
            ("mail", "Mail"),
            ("safari", "Safari"),
            ("notes", "Notes"),
            ("settings", "Settings")
        ]
        
        dockItems = defaultDockItems.map { DockItem(iconName: $0.0, label: $0.1) }
    }
    
    private func setupMotionManager() {
        motionManager = CMMotionManager.shared
        
        // Start accelerometer updates
        do {
            try motionManager?.startAccelerometerUpdates()
        } catch {
            print("Failed to start accelerometer: \(error)")
        }
    }
    
    func toggleShake() {
        guard let manager = motionManager else { return }
        
        // Detect shake
        let detector = manager.ShakeDetector(manager: manager)
        let isShaking = detector.detectShake()
        
        if isShaking {
            // Record shake
            manager.recordShake()
            shakeCount += 1
            lastShakeDate = Date()
            
            // Toggle mode
            switch currentMode {
            case .normal:
                currentMode = .freeMotion
            case .freeMotion:
                currentMode = .returning
            case .returning:
                currentMode = .normal
            }
            
            // Play shake sound (placeholder)
            playShakeSound()
        }
    }
    
    func toggleDebugMode() {
        debugMode.toggle()
    }
    
    private func playShakeSound() {
        // Placeholder for sound effect
    }
    
    func recordShake() {
        shakeCount += 1
        lastShakeDate = Date()
    }
    
    deinit {
        // Stop motion updates
        motionManager?.stopAccelerometerUpdates()
    }
}

// MARK: - Icons
struct Icon: Identifiable {
    let id = UUID()
    let label: String
    let iconName: String
    let iconType: String
}

// MARK: - Dock Items
struct DockItem: Identifiable {
    let id = UUID()
    let iconName: String
    let label: String
}

// MARK: - Current Mode
enum CurrentMode: Equatable {
    case normal
    case freeMotion
    case returning
}

// MARK: - Shake State
enum ShakeState: Equatable {
    case ready
    case cooldown
    case shaking
}
