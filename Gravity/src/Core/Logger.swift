/// Logger - Handles all application logging
class Logger {
    private var logFileURL: URL?
    private var logRotationSize: Int64 = 10 * 1024 * 1024 // 10MB
    private var logHistory: [LogEntry] = []
    
    private let prefix = "[iOSMotion] "
    
    init(logFileURL: URL? = nil) {
        self.logFileURL = logFileURL
        self.logFileURL ??= URL(fileURLWithPath: "/tmp/iOSMotion.log")
    }
    
    func setLogFileURL(_ url: URL) {
        logFileURL = url
    }
    
    func log(level: LogLevel, module: String, message: String) -> LogEntry {
        let entry = LogEntry(
            timestamp: Date(),
            level: level,
            module: module,
            message: message
        )
        logHistory.append(entry)
        
        // Rotate logs if needed
        if logHistory.count > 1000 {
            logHistory.removeFirst(500)
        }
        
        // Write to file
        writeLogEntry(entry)
        
        return entry
    }
    
    private func writeLogEntry(_ entry: LogEntry) {
        guard let url = logFileURL else { return }
        
        let logLine = "\(entry.timestamp.timeIntervalSince1970) [\(entry.level)] [\(entry.module)] \(entry.message)"
        
        let fileHandle = FileHandle(forWritingTo: url)
        defer { fileHandle.closeFile() }
        
        fileHandle.seekToEndFile()
        let currentSize = fileHandle.length
        let maxSize = logRotationSize
        
        if currentSize >= maxSize {
            // Rotate log file
            let oldURL = url.deletingLastPathComponent().appendingPathComponent("iOSMotion_old.log")
            try? FileHandle(forWritingTo: oldURL).write(logLine.data(using: .utf8))
            try? FileManager.default.removeItem(at: oldURL)
        }
        
        fileHandle.write(logLine.data(using: .utf8))
    }
    
    func exportLog() -> Data {
        guard !logHistory.isEmpty else { return Data() }
        return Data(logHistory.map { $0.exportData() })
    }
}

extension LogEntry {
    func exportData() -> Data {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let timestamp = formatter.string(from: timestamp)
        
        let line = "\(timestamp) [\(level)] [\(module)] \(message)"
        return line.data(using: .utf8) ?? Data()
    }
}

extension LogLevel {
    var string: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}
