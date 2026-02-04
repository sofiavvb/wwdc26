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
            ZStack () {
                
                TimelineView(.animation(minimumInterval: 3)) { timeline in
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
                        x: proxy.size.width * 0.2,
                        y: proxy.size.height * 0.05
                    )
                
                FirstLevelGameArea(gameWidth:  proxy.size.width, gameHeight: proxy.size.height, vm: vm)
                    .coordinateSpace(name: "gameArea")
            }
            .task {
                if vm.dropZones.isEmpty {
                    vm.setupDropZones(screenSize: CGSize(width: proxy.size.width * 0.8, height: proxy.size.height))
                }
            }
            .onChange(of: vm.isLevelComplete) { _, isComplete in
                if isComplete {
                    Task {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        navigateToNextLevel = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToNextLevel) {
                SecondLevelView()
            }
        }
    }
}

struct FirstLevelGameArea: View {
    let gameWidth: CGFloat
    let gameHeight: CGFloat
    var vm: FirstLevelViewModel
    
    var body: some View {
        ZStack {
            // MARK: -  Moon
            TimelineView(.animation(minimumInterval: 0.8)) { timeline in
                Image(vm.moonFrames[vm.backgroundFrame])
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFit()
                    .frame(width: gameWidth * 1.2)
                    .position(
                        x: gameWidth * 0.5,
                        y: gameHeight * 0.45
                    )
                    .onChange(of: timeline.date) { _, _ in
                        vm.updateBackgroundFrame()
                    }
            }
            
            // MARK: - Drop zones
            ForEach(vm.dropZones) { dropZone in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: dropZone.size.width, height: dropZone.size.height)
                    .position(dropZone.position)
            }
            
            // MARK: - Tokens in drop zones
            ForEach(vm.dropZones) { dropZone in
                ForEach(Array(dropZone.tokens.keys), id: \.self) { tokenId in
                    if let position = dropZone.tokens[tokenId],
                       let token = findToken(by: tokenId) {
                        DroppedTokenView(token: token, position: position, vm: vm, isLocked: vm.completedZones.contains(dropZone.id))
                    }
                }
            }
            
            DragArea(gameWidth: gameWidth, gameHeight: gameHeight, vm: vm)

        }
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
        Image("dragarea")
            .resizable()
            .position(x: gameWidth * 0.5, y: gameHeight * 0.54)
            .overlay(
                VStack(spacing: 20) {
                    ForEach(vm.availableTokens, id: \.self) { row in
                        HStack(spacing: 20) {
                            ForEach(row) { token in
                                TokenView(token: token, vm: vm)
                            }
                        }
                    }
                }
                .position(x: gameWidth / 2, y: gameHeight * 0.9)
            )
    }
}

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
    FirstLevelView()
}
