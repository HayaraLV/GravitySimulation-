//
//  IconManagerTests.swift
//  iOSMotion Tests
//
//  Tests for icon management
//

import XCTest
@testable import iOSMotion

final class IconManagerTests: XCTestCase {
    
    var iconManager: IconManager!
    
    override func setUp() {
        super.setUp()
        iconManager = IconManager()
    }
    
    override func tearDown() {
        iconManager = nil
        super.tearDown()
    }
    
    func testDefaultGridDimensions() {
        XCTAssertGreaterThan(iconManager.gridWidth, 0)
        XCTAssertGreaterThan(iconManager.gridHeight, 0)
        XCTAssertGreaterThan(iconManager.cellWidth, 0)
        XCTAssertGreaterThan(iconManager.cellHeight, 0)
    }
    
    func testIconGridPosition() {
        let icon = Icon(id: UUID(), label: "Test", iconName: "test", iconType: "test")
        let position = iconManager.computeGridPosition(for: icon.id)
        
        XCTAssertGreaterThan(position.x, 0)
        XCTAssertGreaterThan(position.y, 0)
        XCTAssertLessThan(position.x, iconManager.gridWidth)
        XCTAssertLessThan(position.y, iconManager.gridHeight)
    }
    
    func testUniqueGridPositions() {
        let icons = Array(1...10).map { i in
            Icon(id: UUID(), label: "Icon \(i)", iconName: "icon\(i)", iconType: "icon")
        }
        
        for i in 0..<icons.count {
            let pos1 = iconManager.computeGridPosition(for: icons[i].id)
            let pos2 = iconManager.computeGridPosition(for: icons[i+1].id)
            
            XCTAssertNotEqual(pos1.x, pos2.x, "Column should be different")
            XCTAssertNotEqual(pos1.y, pos2.y, "Row should be different")
        }
    }
}
