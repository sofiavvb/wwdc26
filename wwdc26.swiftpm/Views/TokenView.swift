//
//  TokenView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 02/02/26.
//

import SwiftUI

struct TokenView: View {
    let token: Token
    var vm: LevelViewModel
    var isLocked: Bool = false
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Text(token.text)
            .font(Font.custom("Jersey10-Regular", size: 24))
            .padding()
            .background(
                Image(token.background)
                    .resizable()
            )
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

struct DroppedTokenView: View {
    let token: Token
    let position: CGPoint
    var vm: LevelViewModel
    var isLocked: Bool = false
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        
        Text(token.text)
            .font(Font.custom("Jersey10-Regular", size: 24))
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

#Preview {
    TokenView(token: Token(text: "Why", background: "token-azul"), vm: FirstLevelViewModel())
}
