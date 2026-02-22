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
            .offset(offset)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(vm.selectedToken?.id == token.id ? token.color.opacity(0.8) : Color.clear, lineWidth: 2)
                    .fill(vm.selectedToken?.id == token.id ? token.color.opacity(0.15) : Color.clear)
                    .shadow(color: vm.selectedToken?.id == token.id ? token.color.opacity(0.5) : Color.clear, radius: 5)
            )
            .onTapGesture {
                if vm.selectedToken?.id == token.id {
                    vm.selectedToken = nil
                } else {
                    vm.selectedToken = token
                }
            }
            .gesture(
                DragGesture(coordinateSpace: .named("gameArea"))
                    .onChanged { value in
                        if !vm.isDragging {
                            withAnimation(.easeOut(duration: 0.15)) {
                                vm.isDragging = true
                            }
                        }
                        vm.selectedToken = nil
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.easeIn(duration: 0.2)) {
                            vm.isDragging = false
                        }
                        if let dropZone = vm.getDropZone(at: value.location) {
                            vm.moveToDropZone(token, dropZone: dropZone, at: value.location)
                        }
                        
                        withAnimation(.spring()) { offset = .zero }
                        
                    }
                
            )
            .scaleEffect(vm.isDragging ? 1.08 : 1.0)
            .shadow(radius: vm.isDragging ? 20 : 5)
            .accessibilityElement()
            .accessibilityLabel(token.text)
            .accessibilityHint("Drag or tap to move this token to a drop zone")
            .accessibilityDragPoint(.center, description: "Drag this token")
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
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(vm.selectedToken?.id == token.id ? token.color.opacity(0.8) : Color.clear, lineWidth: 2)
                    .fill(vm.selectedToken?.id == token.id ? token.color.opacity(0.15) : Color.clear)
                    .shadow(color: vm.selectedToken?.id == token.id ? token.color.opacity(0.5) : Color.clear, radius: 5)
                
            )
            .background(
                Image(token.background)
                    .resizable()
            )
            .position(
                x: position.x + offset.width,
                y: position.y + offset.height
            )
            .onTapGesture {
                guard !isLocked else { return }
                if vm.selectedToken?.id == token.id {
                    vm.selectedToken = nil
                } else {
                    vm.selectedToken = token
                }
            }
            .gesture(isLocked ? nil :
                        DragGesture(coordinateSpace: .named("gameArea"))
                .onChanged { value in
                    offset = value.translation
                    vm.selectedToken = nil
                }
                .onEnded { value in
                    if let zone = vm.getDropZone(at: value.location) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
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
            .scaleEffect(vm.incorrectTokensIds.contains(token.id) ? 0.98 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.incorrectTokensIds)
            .accessibilityElement()
            .accessibilityLabel(token.text)
            .accessibilityValue(isLocked ? "already placed correctly" : "you can move or remove this token")
    }
    
}

struct ShakeEffect: GeometryEffect {
    var amplitude: CGFloat = 10
    var shakes: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amplitude * sin(animatableData * .pi * shakes)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
