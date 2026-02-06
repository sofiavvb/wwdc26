//
//  SwiftUIView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 05/02/26.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(SceneManager.self) var sceneManager

    var body: some View {
        VStack {
            Text("Before the Answer").font(Font.custom("Jersey10-Regular", size: 85))
            
            Button {
                sceneManager.currentScene = .intro
            } label : {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 200, height: 50)
                    .font(.title)
                    .padding()
                    .overlay {
                        Text("Play")
                            .font(Font.custom("Jersey10-Regular", size: 35))
                            .foregroundStyle(.black)
                    }
            }
            
//            Button {
//                sceneManager.currentScene = .aboutMe
//            } label : {
//                RoundedRectangle(cornerRadius: 20)
//                    .frame(width: 200, height: 50)
//                    .font(.title)
//                    .padding()
//                    .overlay {
//                        Text("About Me")
//                            .font(Font.custom("Jersey10-Regular", size: 35))
//                            .foregroundStyle(.black)
//                    }
//            }
        }
    }
}

#Preview {
    WelcomeView()
}
