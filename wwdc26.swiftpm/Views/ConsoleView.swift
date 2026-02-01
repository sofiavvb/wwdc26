//
//  ConsoleView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 31/01/26.
//

import SwiftUI

@MainActor
struct ConsoleView: View {
    let geometry: GeometryProxy
    let progress: Double
    let message: String
    let isAnimating: Bool
    let animationFrames: [String]
    
    @State private var currentFrame = 0
    @State private var animationTask: Task<Void, Never>? = nil
    
    var body: some View {
        VStack() {
            // MARK: Global Progress Bar
            VStack() {
                Text("Overall Progress")
                    .font(.headline)
                
                ZStack(alignment: .leading) {
                    // TODO: colocar asset de vdd
                    Image("PassarFala1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.05)
                    
                    // Celebration animation overlay
                    if isAnimating {
                        Image(animationFrames[currentFrame])
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.05)
                            .onAppear {
                                startAnimation()
                            }
                            .onDisappear {
                                stopAnimation()
                            }
                    } else if let frame = GameManager.shared.currentFrame {
                        Image(frame)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.05)
                    }
                }
                
            }
            
            Spacer()
            
            // MARK: Message Display
            Text(message)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
            
        }
        .padding()
        .background(Color.white.opacity(0.1))
    }
    
    private func startAnimation() {
        guard animationTask == nil, !animationFrames.isEmpty else { return }
        
        animationTask = Task {
            for frameIndex in 0..<animationFrames.count {
                guard !Task.isCancelled else { return }
                
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s per frame
                currentFrame = frameIndex
            }
        }
    }
    
    private func stopAnimation() {
        animationTask?.cancel()
        animationTask = nil
    }
}
