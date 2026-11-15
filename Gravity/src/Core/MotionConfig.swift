/// Motion Configuration - All physics and detection parameters
struct MotionConfig {
    // Detection Settings
    let shakeThreshold: Float = 1.5
    let shakeCooldown: TimeInterval = 2.0
    
    // Physics Settings
    let gravityScale: Float = 1.0
    let friction: Float = 0.95
    let bounceStrength: Float = 0.7
    let movementSpeed: Float = 5.0
    let collisionStrength: Float = 1.0
    
    // Icon Settings
    let iconWidth: CGFloat = 60
    let iconHeight: CGFloat = 60
    let iconSpacing: CGFloat = 20
    let iconBorderRadius: CGFloat = 12
    
    // Physics Engine Settings
    let physicsBodyMass: Float = 1.0
    let physicsBodySize: CGFloat = 50
    let physicsRestitution: Float = 0.6
    let physicsFriction: Float = 0.3
}

/// App State - Current mode and status
struct AppState {
    enum Mode {
        case normal
        case freeMotion
        case returning
    }
    
    var mode: Mode = .normal
    var shakeCount: Int = 0
    var lastShakeTime: TimeInterval = 0
    
    init() {
        self.init(mode: .normal)
    }
}

/// Icon Position - Original grid position
struct IconPosition {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let id: String
}

/// Icon State - Current position and velocity
struct IconState {
    var position: CGPoint = .zero
    var velocity: CGPoint = .zero
    var originalPosition: IconPosition
    var isActive: Bool = true
}

/// Log Entry
struct LogEntry {
    let timestamp: Date
    let level: LogLevel
    let module: String
    let message: String
}

enum LogLevel {
    case debug, info, warning, error
}
