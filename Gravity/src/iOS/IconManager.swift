//
//  IconManager.swift
//  iOSMotion
//
//  Manages grid positioning of app icons
//

import Foundation
import PhysicsKit

/// Manages app icons in the home screen grid
class IconManager: ObservableObject {
    @Published var icons: [Icon] = []
    @Published var iconPositions: [String: IconPosition] = [:]
    
    let gridWidth: CGFloat = 200
    let gridHeight: CGFloat = 300
    let cellWidth: CGFloat = 55
    let cellHeight: CGFloat = 55
    let spacing: CGFloat = 7
    
    var physicsWorld: SKPhysicsWorld?
    var iconSKNodes: [IconSKNode] = []
    
    init() {
        setupPhysicsWorld()
    }
    
    private func setupPhysicsWorld() {
        physicsWorld = SKPhysicsWorld()
        
        // Create physics world with gravity
        physicsWorld?.gravity = SKVector(x: 0, y: 9.8)
    }
    
    func addIcon(_ icon: Icon) {
        let position = computeGridPosition(for: icon.id)
        iconPositions[icon.id] = position
        
        let iconNode = IconSKNode(icon: icon, position: position)
        iconNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cellWidth, height: cellHeight))
        iconNode.physicsBody?.isDynamic = false
        iconNode.physicsBody?.allowsRotation = false
        
        physicsWorld?.node(iconNode)
        iconSKNodes.append(iconNode)
        
        // Animate to position
        animateToPosition(iconNode, targetPosition: position)
    }
    
    func updatePosition(for iconId: String, newPosition: IconPosition) {
        if let node = iconSKNodes.first {
            animateToPosition(node, targetPosition: newPosition)
        }
    }
    
    private func computeGridPosition(for iconId: String) -> IconPosition {
        let column = Int(iconId.hashValue % 5)
        let row = (Int(iconId.hashValue / 5)) % 6
        
        let x: CGFloat = CGFloat(column) * (cellWidth + spacing) + (cellWidth / 2)
        let y: CGFloat = CGFloat(row) * (cellHeight + spacing) + (cellHeight / 2)
        
        return IconPosition(x: x, y: y)
    }
    
    private func animateToPosition(_ node: SKNode, targetPosition: IconPosition) {
        let keyPath = "\(#keyPath(node.position))"
        animateKeyPath(keyPath, from: node.position, to: targetPosition, duration: 0.5, easing: .easeOut)
    }
    
    private func animateKeyPath(_ keyPath: String, from: CGFloat, to: CGFloat, duration: TimeInterval, easing: SKAnimation.EasingCurve) {
        // Animation implementation
    }
    
    func removeIcon(_ icon: Icon) {
        if let index = iconSKNodes.first {
            physicsWorld?.node(index)
            iconSKNodes.remove(at: index)
        }
    }
}
