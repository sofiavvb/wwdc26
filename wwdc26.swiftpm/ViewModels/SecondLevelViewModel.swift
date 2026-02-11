//
//  SecondLevelViewModel.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 02/02/26.
//


import SwiftUI

@MainActor
@Observable class SecondLevelViewModel: LevelViewModel {
    let cometFrames = ["Comet1", "Comet2", "Comet3"]
    
    override init() {
        super.init()
        setOriginalTokens(tokensSecondLevel_)
        backgroundFrames = ["lv2-background1", "lv2-background2", "lv2-background3"]
    }
    
    func setupDropZones(screenSize: CGSize) {
        let earthDropZone = DropZone(
            name: "Earth",
            position: CGPoint(x: screenSize.width * 0.245, y: screenSize.height * 0.66),
            size: CGSize(width: screenSize.width * 0.4, height: screenSize.height * 0.1),
            validQuestions: [
                ["Why", "Does", "The Earth", "Rotate?"],
                ["Is", "The Earth", "Travelling?"],
                ["How", "Does", "The Earth", "Rotate?"],
                ["What", "The Earth", "Is", "Made of?"],
                ["What", "Is", "The Earth", "Made of?"],
                ["How", "Is", "The Earth", "Travelling?"],
                ["Why", "Is", "The Earth", "Travelling?"]
            ]
        )
        
        let cometDropZone = DropZone(
            name: "Comet",
            position: CGPoint(x: screenSize.width * 0.76, y: screenSize.height * 0.66),
            size: CGSize(width: screenSize.width * 0.4, height: screenSize.height * 0.1),
            validQuestions: [
                ["How", "Are", "Comets", "Travelling?"],
                ["Why", "Are", "Comets", "Travelling?"],
                ["What", "Are", "Comets", "Made of?"],
                ["How", "Comets", "Are", "Travelling?"],
                ["Does", "Comets", "Rotate?"],
            ]
        )
        
        let saturnDropZone = DropZone(
            name: "Saturn",
            position: CGPoint(x: screenSize.width * 0.6, y: screenSize.height * 0.32),
            size: CGSize(width: screenSize.width * 0.4, height: screenSize.height * 0.1),
            validQuestions: [
                ["Are", "The Rings", "Travelling?"],
                ["Does", "The Rings", "Rotate?"],
                ["What", "Are", "The Rings", "Made of?"],
                ["How", "Does", "The Rings", "Rotate?"],
                ["Why", "Does", "The Rings", "Rotate?"],
                ["How", "Does", "The Rings", "Rotate?"],
                ["Why", "The Rings", "Rotate?"],
                ["How", "The Rings", "Rotate?"],
            ]
        )
        
        dropZones = [earthDropZone, cometDropZone, saturnDropZone]
    }
}


#Preview(traits: .landscapeLeft) {
    let sceneManager = SceneManager()
    SecondLevelView().environment(sceneManager)
}
