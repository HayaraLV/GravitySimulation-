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
