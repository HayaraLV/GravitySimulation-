//
//  MotionConfigTests.swift
//  iOSMotion Tests
//
//  Tests for Motion configuration
//

import XCTest
@testable import iOSMotion

final class MotionConfigTests: XCTestCase {
    
    func testDefaultConfiguration() {
        let config = MotionConfig.default()
        
        XCTAssertGreaterThan(config.shakeThreshold, 0)
        XCTAssertGreaterThan(config.shakeCooldown, 0)
        XCTAssertGreaterThan(config.shakeInterval, 0)
        XCTAssertGreaterThan(config.gravity, 0)
    }
    
    func testCustomConfiguration() {
        let config = MotionConfig(
            shakeThreshold: 2.0,
            shakeCooldown: 2.0,
            shakeInterval: 1.0,
            gravity: 10.0
        )
        
        XCTAssertEqual(config.shakeThreshold, 2.0)
        XCTAssertEqual(config.shakeCooldown, 2.0)
        XCTAssertEqual(config.shakeInterval, 1.0)
        XCTAssertEqual(config.gravity, 10.0)
    }
    
    func testPhysicsParameters() {
        let config = MotionConfig.default()
        
        // Test physics parameters are reasonable
        XCTAssertGreaterThan(config.bounceDamping, 0)
        XCTAssertGreaterThan(config.bounceFriction, 0)
    }
}
