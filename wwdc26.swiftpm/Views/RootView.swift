//
//  WelcomeView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 29/01/26.
//

import SwiftUI

struct RootView: View {
    var sceneManager = SceneManager()
    
    var body: some View {
        Group {
            switch sceneManager.currentScene {
            case .intro:
                IntroView()
            case .question:
                QuestionView()
            case .scientist:
                ScientistView()
            case .game:
                FirstLevelView()
            case .aboutMe:
                EmptyView()
            case .welcome:
                WelcomeView()
            case .endGame:
                Text("End Game").font(Font.custom("Jersey10-Regular", size: 30))
            }
        }.environment(sceneManager)
    }
}

