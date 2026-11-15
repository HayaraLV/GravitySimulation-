//
//  ShakeDetector.swift
//  iOSMotion
//
//  Shake detection with cooldown protection
//

import Foundation
import CoreMotion

/// Shake detector with cooldown protection
class ShakeDetector {
    let manager: CMMotionManager
    var lastMagnitude: Float = 0
    var isShaking: Bool = false
    var shakeCooldown: TimeInterval = 1.0
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    func detectShake() -> ShakeState {
        let now = Date()
        
        // Check cooldown
        if let lastShake = manager.shared.lastShakeDate {
            let timeSinceShake = now.timeIntervalSince(lastShake)
            
            if timeSinceShake > shakeCooldown {
                return .ready
            } else {
                return .cooldown
            }
        }
        
        // Get acceleration magnitude
        let acceleration = manager.shared.accelerometer?.acceleration
        
        if let acc = acceleration {
            let magnitude = sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z)
            lastMagnitude = magnitude
            
            if magnitude >= manager.shakeThreshold {
                isShaking = true
                return .shaking
            } else {
                isShaking = false
                return .ready
            }
        } else {
            return .ready
        }
    }
    
    func recordShake() {
        manager.shared.lastShakeDate = Date()
    }
}

// MARK: - Shake State
enum ShakeState: Equatable {
    case ready
    case cooldown
    case shaking
}
