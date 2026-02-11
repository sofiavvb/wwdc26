//
//  ConsoleView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 31/01/26.
//

import SwiftUI

@MainActor
struct ComponentView: View {
    var currentFrame = GameManager.shared.currentFrame
    
    var body: some View {
        VStack {
            Image(GameManager.shared.componentFrames[currentFrame])
                .resizable()
                .scaledToFit()
                .id(currentFrame)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 1.1)),
                    removal: .opacity
                ))
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.5), value: currentFrame)
    }
}
