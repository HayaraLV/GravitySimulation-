//
//  AppStateTests.swift
//  iOSMotion Tests
//
//  Tests for application state
//

import XCTest
@testable import iOSMotion

final class AppStateTests: XCTestCase {
    
    func testDefaultInitialization() {
        let appState = AppState()
        
        XCTAssertGreaterThan(appState.icons.count, 0)
        XCTAssertGreaterThan(appState.dockItems.count, 0)
        XCTAssertEqual(appState.currentMode, .normal)
        XCTAssertEqual(appState.shakeCount, 0)
        XCTAssertFalse(appState.debugMode)
    }
    
    func testShakeCountIncrement() {
        var appState = AppState()
        
        appState.recordShake()
        XCTAssertEqual(appState.shakeCount, 1)
        
        appState.recordShake()
        XCTAssertEqual(appState.shakeCount, 2)
    }
    
    func testIconCreation() {
        let appState = AppState()
        
        let icon = appState.icons.first
        XCTAssertNotNil(icon)
        XCTAssertEqual(icon?.iconName, "Photos")
    }
    
    func testDockItemCreation() {
        let appState = AppState()
        
        let dockItem = appState.dockItems.first
        XCTAssertNotNil(dockItem)
        XCTAssertEqual(dockItem?.iconName, "phone")
    }
}
