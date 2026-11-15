// SpriteKit Physics Engine for iOS Motion Desktop
// Handles Box2D physics for app icons on the home screen

import SpriteKit
import PhysicsKit

class PhysicsEngine {
    static let shared = PhysicsEngine()
    
    private var scene: SKScene?
    private var physicsWorld: PhysicsWorld?
    private var iconBodies: [SKShapeNode] = []
    
    private init() {}
    
    func setup(scene: SKScene) {
        self.scene = scene
        scene.physicsWorld = physicsWorld = PhysicsWorld()
        scene.physicsWorld.gravity = .vector(0, 500)
        
        setupIconPhysics()
    }
    
    private func setupIconPhysics() {
        guard let physicsWorld = physicsWorld else { return }
        
        // Create physics bodies for icons
        let iconSize = CGSize(width: 50, height: 50)
        
        for icon in iconBodies {
            let body = PhysicsBody.circle(
                position: icon.position,
                shape: SKShape(circle: SKCircleNode(radius: 25))
            )
            body.linearDamping = 0.3
            body.angularDamping = 0.5
            body.linearVelocity = icon.velocity
            body.angularVelocity = icon.rotationRate
            body.mass = 1.0
            
            physicsWorld.addBody(body)
        }
    }
    
    func updatePhysics(delta: TimeInterval) {
        guard let physicsWorld = physicsWorld else { return }
        
        // Update all icon physics bodies
        for (index, icon) in iconBodies.enumerated() {
            let body = physicsWorld.body(for: index)
            if let body = body {
                body.update(for: physicsWorld, delta: delta)
                icon.position = body.position
                icon.scale = body.scale
            }
        }
    }
    
    func applyShake(force: CMAcceleration) {
        guard let physicsWorld = physicsWorld else { return }
        
        // Apply force to all icon bodies
        for (index, icon) in iconBodies.enumerated() {
            let body = physicsWorld.body(for: index)
            if let body = body {
                let forceVector = CMAcceleration(
                    x: force.x * 0.5,
                    y: force.y * 0.5,
                    z: force.z * 0.5
                )
                body.applyForce(at: body.position, with: forceVector)
            }
        }
    }
    
    func clear() {
        for icon in iconBodies {
            icon.removeFromParent()
        }
        iconBodies.removeAll()
        physicsWorld?.removeAllBodies()
    }
}

class PhysicsWorld {
    private var bodies: [(index: Int, body: PhysicsBody, icon: SKShapeNode)] = []
    
    func addBody(_ body: PhysicsBody, icon: SKShapeNode) {
        let index = bodies.count
        bodies.append((index: index, body: body, icon: icon))
    }
    
    func body(for index: Int) -> PhysicsBody? {
        return bodies[index].body
    }
    
    func removeAllBodies() {
        for (index, item) in bodies.enumerated() {
            item.body.removeFromParent()
            item.icon.removeFromParent()
        }
        bodies.removeAll()
    }
}
