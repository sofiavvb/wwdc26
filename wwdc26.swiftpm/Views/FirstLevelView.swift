//
//  FirstLevel.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 29/01/26.
//

import SwiftUI
import Foundation

struct FirstLevelView: View {
    @State private var vm = FirstLevelViewModel()
    @State private var navigateToNextLevel = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("placeholderlv1")
                    .resizable()
                    .ignoresSafeArea()
                
                HStack(spacing: 0){
                    ConsoleView(
                        geometry: proxy,
                        progress: GameManager.shared.progress,
                        message: GameManager.shared.consoleMessage,
                        isAnimating: vm.showCelebration,
                        animationFrames: GameManager.shared.level1AnimationFrames
                    )
                    
                    GameArea(gameWidth:  proxy.size.width * 0.8, gameHeight: proxy.size.height, vm: vm)
                        .coordinateSpace(name: "gameArea")
                }
                
            }
            .task {
                if vm.dropZones.isEmpty {
                    vm.setupDropZones(screenSize: CGSize(width: proxy.size.width * 0.8, height: proxy.size.height))
                }
            }
            .onChange(of: vm.isLevelComplete) { _, isComplete in
                if isComplete {
                    Task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        navigateToNextLevel = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToNextLevel) {
                WelcomeView()
            }
        }
    }
}

struct GameArea: View {
    let gameWidth: CGFloat
    let gameHeight: CGFloat
    var vm: FirstLevelViewModel
    
    var body: some View {
        ZStack {
            // MARK: Moon
            Circle()
                .fill(Color.gray.opacity(0.7))
                .frame(width: gameWidth * 0.15, height: gameHeight * 0.16)
                .position(
                    x: gameWidth * 0.5,
                    y: gameHeight * 0.3
                )
            
            // MARK: Drop zones
            ForEach(vm.dropZones) { dropZone in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: dropZone.size.width, height: dropZone.size.height)
                    .position(dropZone.position)
            }
            
            // MARK: Tokens in drop zones
            ForEach(vm.dropZones) { dropZone in
                ForEach(Array(dropZone.tokens.keys), id: \.self) { tokenId in
                    if let position = dropZone.tokens[tokenId],
                       let token = findToken(by: tokenId) {
                        DroppedTokenView(token: token, position: position, vm: vm)
                    }
                }
            }
            
            DragArea(gameWidth: gameWidth, gameHeight: gameHeight, vm: vm)
                .frame(width: gameWidth, height: gameHeight * 0.25)
                .position(x: gameWidth / 2, y: gameHeight * 0.92)
            
        }
        .frame(width: gameWidth, height: gameHeight)
    }
    
    private func findToken(by id: UUID) -> Token? {
        return tokensFirstLevel_.flatMap { $0 }.first { $0.id == id }
    }
}

struct DragArea: View {
    let gameWidth: CGFloat
    let gameHeight: CGFloat
    @Bindable var vm: LevelViewModel
    
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .overlay(
                VStack(spacing: 15) {
                    ForEach(vm.availableTokens, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row) { token in
                                TokenView(token: token, vm: vm)
                            }
                        }
                    }
                }
                    .padding()
            )
    }
}

struct DroppedTokenView: View {
    let token: Token
    let position: CGPoint
    var vm: LevelViewModel
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Text(token.text)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .position(
                x: position.x + offset.width,
                y: position.y + offset.height
            )
            .gesture(
                DragGesture(coordinateSpace: .named("gameArea"))
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        if let _ = vm.getDropZone(at: value.location) {
                            vm.updatePositionInDropZone(token, at: value.location)
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

struct TokenView: View {
    let token: Token
    var vm: LevelViewModel
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Text(token.text)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
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
    }
}

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
    FirstLevelView()
}
