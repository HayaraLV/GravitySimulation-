//
//  ContentView.swift
//  iOSMotion
//
//  Main SwiftUI View
//

import SwiftUI
import SpriteKit
import physics

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Home Screen Background
            Color.black.ignoresSafeArea()
            
            // Dock Area
            GeometryReader { geometry in
                DockView(geometry: geometry)
                    .padding(.bottom, 50)
            }
            .ignoresSafeArea()
            
            // App Icons Grid
            VStack {
                ForEach(appState.icons) { icon in
                    IconView(icon: icon, position: appState.iconPositions[icon.id] ?? IconPosition(x: 0, y: 0))
                        .padding(10)
                }
            }
            
            // Status Bar
            VStack {
                HStack {
                    Text("iOS Motion")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 8)
                Spacer()
            }
            
            // Debug Info (only in debug mode)
            if appState.debugMode {
                DebugView(appState: appState)
            }
        }
    }
}

// MARK: - Icon View
struct IconView: View {
    let icon: Icon
    let position: IconPosition
    
    var body: some View {
        VStack {
            Image(systemName: icon.iconName)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            Text(icon.label)
                .font(.system(size: 10))
                .foregroundColor(.white)
                .padding(.top, 4)
        }
        .padding(8)
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
        .offset(x: position.x, y: position.y)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: position)
    }
}

// MARK: - Dock View
struct DockView: View {
    let geometry: GeometrySize
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(appState.dockItems) { dockItem in
                VStack {
                    Image(systemName: dockItem.iconName)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                    Text(dockItem.label)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
            }
        }
        .padding(15)
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
}

// MARK: - Debug View
struct DebugView: View {
    let appState: AppState
    
    var body: some View {
        VStack {
            Text("Debug Mode - Tap Version to Toggle")
                .font(.system(size: 12))
                .foregroundColor(.green)
            
            Text("Shake Count: \(appState.shakeCount)")
                .font(.system(size: 12))
                .foregroundColor(.blue)
            
            Text("Last Shake: \(appState.lastShakeDate)")
                .font(.system(size: 12))
                .foregroundColor(.orange)
            
            Text("Current Mode: \(appState.currentMode)")
                .font(.system(size: 12))
                .foregroundColor(.purple)
            
            Spacer()
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
