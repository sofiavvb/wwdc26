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
            
            GeometryReader { geometry in
                VStack() {
                    Spacer()
                    Text(sceneManager.displayedText)
                        .font(Font.custom(sceneManager.font, size: 75))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 800, alignment: .leading)
                        .padding(.horizontal, 70)
                        .offset(x: geometry.size.width / 8)

                    
                    Button {
                        sceneManager.skip()
                    } label : {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 200, height: 50)
                            .font(.title)
                            .padding()
                            .overlay {
                                Text("Skip")
                                    .font(Font.custom(sceneManager.font, size: 35))
                                    .foregroundStyle(.white)
                            }
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

