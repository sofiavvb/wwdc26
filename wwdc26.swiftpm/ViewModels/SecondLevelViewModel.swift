//
//  SecondLevelViewModel.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 02/02/26.
//


import SwiftUI

@MainActor
@Observable class SecondLevelViewModel: LevelViewModel {
    override init() {
        super.init()
        setOriginalTokens(tokensSecondLevel_)
    }
    
    func setupDropZones(screenSize: CGSize) {
        let earthDropZone = DropZone(
            name: "Earth",
            position: CGPoint(x: screenSize.width * 0.28, y: screenSize.height * 0.25),
            size: CGSize(width: screenSize.width * 0.5, height: screenSize.height * 0.1),
            validQuestions: [
                ["Why", "Does", "The Earth", "Rotate?"],
                ["Is", "The Earth", "Traveling?"],
                ["How", "Does", "The Earth", "Rotate?"],
                ["What", "The Earth", "Is", "Made of?"],
                ["What", "Is", "The Earth", "Made of?"],
            ]
        )
        
        let cometDropZone = DropZone(
            name: "Comet",
            position: CGPoint(x: screenSize.width * 0.3, y: screenSize.height * 0.68),
            size: CGSize(width: screenSize.width * 0.5, height: screenSize.height * 0.1),
            validQuestions: [
                ["How", "Are", "Comets", "Travelling?"],
                ["Why", "Are", "Comets", "Travelling?"],
                ["What", "Are", "Comets", "Made of?"],
                ["How", "Comets", "Are", "Travelling?"],
            ]
        )
        
        let saturnDropZone = DropZone(
            name: "Saturn",
            position: CGPoint(x: screenSize.width * 0.7, y: screenSize.height * 0.48),
            size: CGSize(width: screenSize.width * 0.5, height: screenSize.height * 0.1),
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

#Preview(traits: .landscapeLeft){
    SecondLevelView()
}
