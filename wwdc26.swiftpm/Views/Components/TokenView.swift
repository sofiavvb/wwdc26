//
//  TokenView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 02/02/26.
//

import SwiftUI

struct TokenView: View {
    @Environment(SceneManager.self) var sceneManager
    let token: Token
    var vm: LevelViewModel
    var isLocked: Bool = false
    
    private var isHighlighted: Bool {
        vm.highlightedTokenIds.contains(token.id)
    }
    
    @State private var offset: CGSize = .zero
    @State private var pulse: CGFloat = 1.0
    @State private var glow: Double = 0.0
    
    var body: some View {
        Text(token.text)
            .font(Font.custom(sceneManager.font, size: 24))
            .foregroundStyle(.black)
            .padding()
            .background(
                Image(token.background)
                    .resizable()
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 3)
                    .opacity(glow)
                    .blur(radius: 5)
            )
            .shadow(color: Color.white.opacity(glow * 0.5), radius: 15)
            .scaleEffect(pulse)
            .offset(offset)
            .gesture(
                DragGesture(coordinateSpace: .named("gameArea"))
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        if let dropZone = vm.getDropZone(at: value.location) {
                            vm.moveToDropZone(token, dropZone: dropZone, at: value.location)
                        }
                        
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
            .onChange(of: isHighlighted) { _, highlighted in
                if highlighted {
                    startPulsing()
                } else {
                    stopPulsing()
                }
            }
    }
    
    private func startPulsing() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            pulse = 1.05
            glow = 0.7
        }
    }
    
    private func stopPulsing() {
        withAnimation(.easeOut(duration: 0.3)) {
            pulse = 1.0
            glow = 0.0
        }
    }
}

struct DroppedTokenView: View {
    @Environment(SceneManager.self) var sceneManager
    let token: Token
    let position: CGPoint
    var vm: LevelViewModel
    var isLocked: Bool = false
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        
        Text(token.text)
            .font(Font.custom(sceneManager.font, size: 24))
            .foregroundStyle(.black)
            .padding()
            .background(
                Image(token.background)
                    .resizable()
            )
            .position(
                x: position.x + offset.width,
                y: position.y + offset.height
            )
            .gesture(isLocked ? nil :
                        DragGesture(coordinateSpace: .named("gameArea"))
                .onChanged { value in
                    offset = value.translation
                }
                .onEnded { value in
                    if let zone = vm.getDropZone(at: value.location) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            vm.moveToDropZone(token, dropZone: zone, at: value.location)
                        }
                    } else {
                        vm.moveBackToDragArea(token)
                    }
                    
                    withAnimation(.spring()) {
                        offset = .zero
                    }
                }
            )
    }
}

