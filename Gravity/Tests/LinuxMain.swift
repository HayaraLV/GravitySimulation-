//
//  LinuxMain.swift
//  iOSMotion Tests
//
//  Main entry point for XCTest
//

import XCTest
@testable import iOSMotion

XCTMain([
    testCase(MotionConfigTests.allTests),
    testCase(ShakeDetectorTests.allTests),
    testCase(AppStateTests.allTests),
    testCase(IconManagerTests.allTests),
    testCase(DockManagerTests.allTests),
    testCase(LoggerTests.allTests)
])
