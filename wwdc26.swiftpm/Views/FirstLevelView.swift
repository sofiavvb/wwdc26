//
//  FirstLevel.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 29/01/26.
//

import SwiftUI
import Foundation

struct FirstLevelView: View {
    @State var vm = FirstLevelViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // MARK: Background
                Image("placeholderlv1")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                // MARK: Moon
                Circle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: proxy.size.width * 0.2, height: proxy.size.height * 0.16)
                    .position(
                        x: proxy.size.width * 0.5,
                        y: proxy.size.height * 0.3
                    )
                
                // MARK: Drop area
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: proxy.size.width * 0.45, height: proxy.size.height * 0.1)
                    .position(
                        x: proxy.size.width * 0.5,
                        y: proxy.size.height * 0.50
                    )
                
                ForEach(Array(vm.droppedTokens.keys), id: \.self) { tokenId in
                    if let position = vm.droppedTokens[tokenId],
                       let token = findToken(by: tokenId) {
                        DroppedTokenView(token: token, position: position, vm: vm)
                    }
                }
                
                // MARK: Console
                
                // MARK: Drag and Drop Area
                DragArea(in: proxy)
            }.onAppear {
                vm.setupDropZones(screenSize: proxy.size)
            }
        }
    }
    
    // TODO: ver como refatorar para reutilizar isso no segundo level
    @ViewBuilder
    func DragArea(in geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
            VStack(spacing: 15) {
                ForEach(vm.availableTokens, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row) { token in
                            TokenView(token: token, vm: vm)
                        }
                    }
                }
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
        .position(
            x: geometry.size.width * 0.5,
            y: geometry.size.height - 80
        )
    }
    
    private func findToken(by id: UUID) -> Token? {
        return tokensFirstLevel_.flatMap { $0 }.first { $0.id == id }
    }
    
}

struct DroppedTokenView: View {
    let token: Token
    let position: CGPoint
    var vm: FirstLevelViewModel
    
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
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        if vm.isInAnyDropZone(value.location) {
                            vm.updatePositionInDropZone(token, at: value.location)
                        } else {
                            //if we move it to outside of the drop zone
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
    var vm: FirstLevelViewModel
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Text(token.text)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .offset(offset)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        if vm.isInAnyDropZone(value.location) {
                            vm.moveToDropZone(token, at: value.location)
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
