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
                
                TimelineView(.animation(minimumInterval: 2)) { timeline in
                    Image(vm.backgroundFrames[vm.backgroundFrame])
                        .resizable()
                        .ignoresSafeArea()
                        .onChange(of: timeline.date) { _, _ in
                            vm.updateBackgroundFrame()
                        }
                }
                    ComponentView()
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.8)
                    .position(
                        x: proxy.size.width * 0.18,
                        y: proxy.size.height * 0.04
                    )
                    
                    SecondLevelGameArea(proxy: proxy, vm: vm).coordinateSpace(name: "gameArea")
                
                
            }
            .task {
                if vm.dropZones.isEmpty {
                    vm.setupDropZones(screenSize: proxy.size)
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
            
            Image("Earth")
                .resizable()
                .scaledToFit()
                .frame(width: gameWidth * 0.25, height: gameHeight * 0.24)
                .position(
                    x: gameWidth * 0.25,
                    y: gameHeight * 0.34
                )
            
            TimelineView(.animation(minimumInterval: 0.8)) { timeline in
                Image(vm.cometFrames[vm.backgroundFrame])
                    .resizable()
                    .scaledToFit()
                    .frame(width: gameWidth * 0.38, height: gameHeight * 0.25)
                    .position(
                        x: gameWidth * 0.78,
                        y: gameHeight * 0.5
                    )
                    .onChange(of: timeline.date) { _, _ in
                        vm.updateBackgroundFrame()
                    }
            }
            
            Image("Saturn")
                .resizable()
                .scaledToFit()
                .frame(width: gameWidth * 0.4, height: gameHeight * 0.2)
                .position(
                    x: gameWidth * 0.75,
                    y: gameHeight * 0.12
                )
                
            
            // MARK: Drop zones
            ForEach(vm.dropZones) { dropZone in
                RoundedRectangle(cornerRadius: 15)
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
    let sceneManager = SceneManager()
    SecondLevelView().environment(sceneManager)
}
