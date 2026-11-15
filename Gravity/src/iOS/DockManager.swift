//
//  DockManager.swift
//  iOSMotion
//
//  Manages dock icons at the bottom of the screen
//

import Foundation
import PhysicsKit

/// Manages dock icons in the bottom dock area
class DockManager: ObservableObject {
    @Published var dockItems: [DockItem] = []
    
    let dockWidth: CGFloat = 250
    let dockHeight: CGFloat = 60
    let itemWidth: CGFloat = 50
    let itemHeight: CGFloat = 50
    let spacing: CGFloat = 10
    
    var physicsWorld: SKPhysicsWorld?
    var dockNodes: [DockSKNode] = []
    
    init() {
        setupPhysicsWorld()
        populateDefaultItems()
    }
    
    private func setupPhysicsWorld() {
        physicsWorld = SKPhysicsWorld()
        physicsWorld?.gravity = SKVector(x: 0, y: 9.8)
    }
    
    private func populateDefaultItems() {
        let defaultItems: [(iconName: String, label: String)] = [
            ("phone", "Phone"),
            ("mail", "Mail"),
            ("safari", "Safari"),
            ("notes", "Notes"),
            ("settings", "Settings")
        ]
        
        dockItems = defaultItems.map { DockItem(iconName: $0.0, label: $0.1) }
    }
    
    func addDockItem(_ item: DockItem) {
        let x: CGFloat = CGFloat(dockItems.first?.index + 1) * (itemWidth + spacing) + (itemWidth / 2)
        let y: CGFloat = dockHeight / 2
        
        let node = DockSKNode(item: item, position: CGPoint(x: x, y: y))
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: itemWidth, height: itemHeight))
        node.physicsBody?.isDynamic = false
        
        physicsWorld?.node(node)
        dockNodes.append(node)
    }
    
    func removeDockItem(_ item: DockItem) {
        if let index = dockNodes.first {
            physicsWorld?.node(index)
            dockNodes.remove(at: index)
        }
    }
    
    func updateDockPosition(for index: Int, newPosition: CGPoint) {
        if let node = dockNodes[index] {
            node.position = newPosition
        }
    }
    
    struct DockItem: Identifiable {
        let id = UUID()
        let iconName: String
        let label: String
    }
}
