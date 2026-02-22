//
//  WelcomeView.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 29/01/26.
//

import SwiftUI

struct RootView: View {
    let sceneManager = SceneManager()
    
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
            case .welcome:
                WelcomeView()
            case .endGame:
                EndGameView()
            case .endScene:
                EndScene()
            }
        }
        .onChange(of: sceneManager.currentScene) { _, newScene in
            handleMusic(for: newScene)
        }
        .task {
            handleMusic(for: sceneManager.currentScene)
        }
        .environment(sceneManager)
    }
    
    func handleMusic(for scene: SceneType) {
        switch scene {
        case .intro, .welcome, .question, .game, .endGame, .endScene:
            SoundManager.shared.playMusic(named: "intro2")
        case .scientist:
            SoundManager.shared.playMusic(named: "intro2")
            //SoundManager.shared.playSoundEffect(named: "ship")
        default:
            SoundManager.shared.stopMusic()
            break
        }
    }
}
