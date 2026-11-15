//
//  ShakeDetectorTests.swift
//  iOSMotion Tests
//
//  Tests for shake detection
//

import XCTest
@testable import iOSMotion

final class ShakeDetectorTests: XCTestCase {
    
    var detector: ShakeDetector!
    
    override func setUp() {
        super.setUp()
        let manager = CMMotionManager(shakeThreshold: 1.5, shakeCooldown: 1.0)
        detector = ShakeDetector(manager: manager)
    }
    
    override func tearDown() {
        detector = nil
        super.tearDown()
    }
    
    func testInitialState() {
        let state = detector.detectShake()
        XCTAssertEqual(state, .ready)
        XCTAssertFalse(detector.isShaking)
    }
    
    func testShakingState() {
        // Simulate high acceleration
        let manager = detector.manager
        manager.shared.lastMagnitude = 2.0  // High magnitude
        
        let state = detector.detectShake()
        XCTAssertEqual(state, .shaking)
        XCTAssertTrue(detector.isShaking)
    }
    
    func testReadyStateAfterCooldown() {
        let manager = detector.manager
        manager.shared.lastShakeDate = Date()
        
        let state = detector.detectShake()
        XCTAssertEqual(state, .cooldown)
        
        // Simulate cooldown passed
        manager.shared.lastShakeDate = Date().addingTimeInterval(2.0)
        
        let state2 = detector.detectShake()
        XCTAssertEqual(state2, .ready)
    }
}
