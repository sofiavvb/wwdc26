//
//  EndGameView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 10/02/26.
//

import SwiftUI

struct EndGameView: View {
    @Environment(SceneManager.self) var sceneManager

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    Image("Component5")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.2, height: geometry.size.height * 1.2)
                        .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.28)
                    
                    
                    Text(sceneManager.displayedText)
                        .font(Font.custom("Jersey10-Regular", size: 60))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 800)
                        .padding(.horizontal, 70)
                }
                
                Button {
                    sceneManager.skip()
                } label : {
                    Image("skipbutton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .scaleEffect(sceneManager.isTextComplete ? 1.13 : 1.0, anchor: .center)
                        .shadow(
                            color: sceneManager.isTextComplete ? .teal.opacity(0.5) : .clear,
                            radius: sceneManager.isTextComplete ? 10 : 0
                        )
                        .animation(
                            sceneManager.isTextComplete
                            ? .smooth(duration: 0.8).repeatForever(autoreverses: true)
                            : .default,
                            value: sceneManager.isTextComplete
                        )
                }
                .position(x: geometry.size.width * 0.85, y: geometry.size.height * 0.85)
                .padding(.horizontal, 60)
                .padding(.vertical, 45)
            }
        }.onChange(of: sceneManager.dialogCompleted) {
            sceneManager.navigate(to: .endScene)
        }
    }
}
