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
        ZStack{
            Image("welcome")
                .resizable()
                .scaledToFill()
            
            Button {
                sceneManager.currentScene = .intro
                SoundManager.shared.playSoundEffect(named: "buttonSound")
            } label : {
                Image("startbutton")
                    .resizable()
                    .scaledToFit()
                    .overlay{
                        Text("START")
                            .font(Font.custom(sceneManager.font, size: 30))
                            .foregroundStyle(Color(hex: "#0D201F"))
                    }
                    .frame(width: 200, height: 150)
            }
        }                .ignoresSafeArea(edges: .all)

    }
}

#Preview {
    WelcomeView()
}
