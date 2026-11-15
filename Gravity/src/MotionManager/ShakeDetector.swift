/// Shake Detector - Detects device shake events
class ShakeDetector {
    private let config: MotionConfig
    private var shakeCount: Int = 0
    private var shakeStartTime: Date?
    private let shakeThreshold: Float
    private let shakeCooldown: TimeInterval
    
    init(config: MotionConfig) {
        self.config = config
        self.shakeThreshold = config.shakeThreshold
        self.shakeCooldown = config.shakeCooldown
        self.shakeCount = 0
        self.shakeStartTime = nil
    }
    
    /// Calculates shake intensity from accelerometer data
    func calculateShakeIntensity(acceleration: CMAcceleration) -> Float {
        let magnitude = hypot(
            hypot(acceleration.x, acceleration.y),
            acceleration.z
        )
        return magnitude
    }
    
    /// Checks if current shake intensity exceeds threshold
    func isShakeDetected(intensity: Float) -> Bool {
        return intensity >= shakeThreshold
    }
    
    /// Records a shake event with cooldown protection
    func recordShakeEvent() {
        let now = Date()
        let timeSinceLastShake = now.timeIntervalSince(shakeStartTime ?? now)
        
        if timeSinceLastShake >= shakeCooldown {
            shakeCount += 1
            shakeStartTime = now
        }
    }
    
    /// Gets current shake state
    func getShakeState() -> (count: Int, timeSinceLastShake: TimeInterval) {
        let now = Date()
        let timeSinceLastShake = now.timeIntervalSince(shakeStartTime ?? now)
        return (shakeCount, timeSinceLastShake)
    }
    
    /// Resets shake counter
    func reset() {
        shakeCount = 0
        shakeStartTime = nil
    }
}
