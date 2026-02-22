//
//  IntroView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 05/02/26.
//

import SwiftUI

struct IntroView: View {
    @Environment(SceneManager.self) var sceneManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack() {
                Spacer()
                Text(sceneManager.displayedText)
                    .font(Font.custom(sceneManager.font, size: 72))
                    .foregroundColor(.white)
                    .frame(maxWidth: 900, maxHeight: 800, alignment: .leading)
                
                HStack {
                    Spacer()
                    Button {
                        sceneManager.skip()
                        SoundManager.shared.playSoundEffect(named: "buttonSound")
                    } label : {
                        Image("skipbutton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
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
                    .padding()
                    .offset(x: -20)
                }
            }.frame(maxWidth: .infinity)
        }.task{
            sceneManager.startDialog()
        }.onChange(of: sceneManager.dialogCompleted) {
            sceneManager.navigate(to: .scientist)
        }.onTapGesture {
            sceneManager.skip()
        }
    }
}

