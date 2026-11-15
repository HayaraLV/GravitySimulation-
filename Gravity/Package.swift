// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "iOSMotionDesktop",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .linux(.v5),
    ],
    targets: [
        // Permutable Core Module - Linux Compatible
        .target(
            name: "Core",
            dependencies: [],
            swiftSettings: [
                .safe("OSX"),
            ],
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"],
            swiftSettings: [
                .safe("OSX"),
            ],
        ),
        // iOS Specific Module
        .target(
            name: "iOSModule",
            dependencies: ["Core"],
            swiftSettings: [
                .unsafe("iOS"),
            ],
        ),
        // iOS Tests
        .testTarget(
            name: "iOSModuleTests",
            dependencies: ["iOSModule"],
        ),
        // Linux CLI Simulator
        .executableTarget(
            name: "MotionSimulator",
            dependencies: ["Core"],
            path: "src/simulator",
            swiftSettings: [
                .safe("OSX"),
            ],
        ),
    ],
)
