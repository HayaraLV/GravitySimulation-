//
//  CMMotionManager.swift
//  iOSMotion
//
//  Core Motion Manager for iOS 27.0.1
//

import Foundation
import CoreMotion

/// Core Motion Manager for shake detection and accelerometer data
class CMMotionManager {
    static let shared = CMMotionManager()
    
    var motionDevice: CMDevice?
    var shakeThreshold: Float
    var shakeCooldown: TimeInterval
    var shakeInterval: TimeInterval
    
    init(
        shakeThreshold: Float = 1.5,
        shakeCooldown: TimeInterval = 1.0,
        shakeInterval: TimeInterval = 0.5
    ) {
        self.shakeThreshold = shakeThreshold
        self.shakeCooldown = shakeCooldown
        self.shakeInterval = shakeInterval
        
        // Initialize with available device
        motionDevice = CMDevice.systemBus()
        shared.accelerometer = CMAccelerometer()
    }
    
    /// Start monitoring accelerometer data
    func startAccelerometerUpdates() throws {
        guard let device = motionDevice else {
            throw CMMotionError.noDevice
        }
        
        shared.accelerometer = CMAccelerometer()
        
        // Start accelerometer updates
        let accelerationWithGravity = CMAccelerationWithGravity()
        shared.accelerometer = accelerationWithGravity
        
        // Start updates
        shared.accelerometer.startUpdates(with: shared.delegate)
    }
    
    /// Get current shake state
    func getShakeState() -> ShakeState {
        let now = Date()
        
        if let lastShake = shared.lastShakeDate {
            let timeSinceShake = now.timeIntervalSince(lastShake)
            
            if timeSinceShake > shakeCooldown {
                return .ready
            } else {
                return .cooldown
            }
        }
        
        return .ready
    }
    
    /// Record a shake event
    func recordShake() {
        shared.lastShakeDate = Date()
    }
    
    /// Stop accelerometer updates
    func stopAccelerometerUpdates() {
        shared.accelerometer.stopUpdates()
    }
    
    private let delegate = CMMotionManagerDelegate()
    
    enum CMMotionError: Swift.Error, LocalizedError {
        case noDevice
        case invalidOperation
        
        var errorDescription: String? {
            switch self {
            case .noDevice:
                return "No motion device available"
            case .invalidOperation:
                return "Invalid operation"
            }
        }
    }
}

extension CMMotionManager {
    /// Shake detection using accelerometer magnitude
    struct ShakeDetector {
        let manager: CMMotionManager
        var lastMagnitude: Float = 0
        var isShaking: Bool = false
        
        func detectShake() -> Bool {
            guard let device = manager.motionDevice else {
                return false
            }
            
            let acceleration = manager.shared.accelerometer?.acceleration
            let magnitude = acceleration != nil ? sqrt(acceleration!.x*acceleration!.x + 
                                                      acceleration!.y*acceleration!.y + 
                                                      acceleration!.z*acceleration!.z) : 0
            
            isShaking = magnitude >= manager.shakeThreshold
            
            return isShaking
        }
    }
}
