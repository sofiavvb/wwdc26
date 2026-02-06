//
//  SecondLevelView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 02/02/26.
//


import SwiftUI

struct SecondLevelView: View {
    @State private var vm = SecondLevelViewModel()
    @Environment(SceneManager.self) var sceneManager

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("lv1-background1")
                    .resizable()
                    .ignoresSafeArea()
                
                
                    ComponentView()
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.8)
                    .position(
                        x: proxy.size.width * 0.2,
                        y: proxy.size.height * 0.05
                    )
                    
                    SecondLevelGameArea(proxy: proxy, vm: vm).coordinateSpace(name: "gameArea")
                
                
            }
            .task {
                if vm.dropZones.isEmpty {
                    let gameAreaSize = CGSize(
                        width: proxy.size.width * 0.8,
                        height: proxy.size.height
                    )
                    print("Setting up Level 2 with game area size:", gameAreaSize)
                    vm.setupDropZones(screenSize: gameAreaSize)
                }
            }
            .onChange(of: vm.isLevelComplete) { _, isComplete in
                if isComplete {
                    Task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        sceneManager.navigate(to: .endGame)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Second Level Game Area
struct SecondLevelGameArea: View {
    let proxy: GeometryProxy
    @Bindable var vm: SecondLevelViewModel
    
    private var gameWidth: CGFloat { proxy.size.width }
    private var gameHeight: CGFloat { proxy.size.height }
    
    var body: some View {
        ZStack {
            DragArea(gameWidth: gameWidth, gameHeight: gameHeight, vm: vm)
            
            // MARK: Object Placeholders (Above drop zones)
            // Earth placeholder (Left)
            Circle()
                .fill(Color.blue.opacity(0.7))
                .frame(width: gameWidth * 0.12, height: gameHeight * 0.12)
                .position(
                    x: gameWidth * 0.25,
                    y: gameHeight * 0.1
                )
            
            // Comet placeholder (Center)
            Circle()
                .fill(Color.cyan.opacity(0.7))
                .frame(width: gameWidth * 0.12, height: gameHeight * 0.12)
                .position(
                    x: gameWidth * 0.28,
                    y: gameHeight * 0.5
                )
            
            // Saturn placeholder (Right)
            Circle()
                .fill(Color.orange.opacity(0.7))
                .frame(width: gameWidth * 0.12, height: gameHeight * 0.12)
                .position(
                    x: gameWidth * 0.7,
                    y: gameHeight * 0.3
                )
                
            
            // MARK: Drop zones
            ForEach(vm.dropZones) { dropZone in
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        vm.completedZones.contains(dropZone.id)
                        ? Color.green.opacity(0.3)
                        : Color.gray.opacity(0.3)
                    )
                    .frame(width: dropZone.size.width, height: dropZone.size.height)
                    .position(dropZone.position)
            }
            
            // MARK: Tokens in drop zones
            ForEach(vm.dropZones) { dropZone in
                ForEach(Array(dropZone.tokens.keys), id: \.self) { tokenId in
                    if let position = dropZone.tokens[tokenId],
                       let token = findToken(by: tokenId) {
                        DroppedTokenView(token: token,
                                         position: position,
                                         vm: vm,
                                         isLocked: vm.completedZones.contains(dropZone.id)
                        )
                    }
                }
            }
            
        }
        .frame(width: gameWidth, height: gameHeight)
    }
    
    private func findToken(by id: UUID) -> Token? {
        return tokensSecondLevel_.flatMap { $0 }.first { $0.id == id }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
    var sceneManager = SceneManager()
    SecondLevelView().environment(sceneManager)
}
