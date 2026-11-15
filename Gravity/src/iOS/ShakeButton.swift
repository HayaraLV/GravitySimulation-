//
//  ShakeButton.swift
//  iOSMotion
//
//  Shake button for triggering shake detection
//

import SwiftUI

struct ShakeButton: View {
    let appState: AppState
    
    var body: some View {
        Button(action: appState.toggleShake) {
            Text("Shake")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .cornerRadius(5)
        }
        .disabled(appState.currentMode != .normal)
    }
}

struct ShakeButton_Previews: PreviewProvider {
    static var previews: some View {
        ShakeButton(appState: AppState())
    }
}
