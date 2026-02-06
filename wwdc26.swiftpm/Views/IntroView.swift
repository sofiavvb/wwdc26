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
                Text(sceneManager.displayedText)
                    .font(Font.custom("Jersey10-Regular", size: 75))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 800)
                    .padding(.horizontal, 70)
                
                Button {
                    sceneManager.skip()
                } label : {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 50)
                        .font(.title)
                        .padding()
                        .overlay {
                            Text("Skip")
                                .font(Font.custom("Jersey10-Regular", size: 35))
                                .foregroundStyle(.white)
                        }
                }
            }
            
        }.task{
            sceneManager.startDialog()
        }.onChange(of: sceneManager.dialogCompleted) {
            sceneManager.navigate(to: .question)
        }.onTapGesture {
            sceneManager.skip()
        }
    }
}

