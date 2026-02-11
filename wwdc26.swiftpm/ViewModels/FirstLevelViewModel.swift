//
//  FirstLevelViewModel.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 30/01/26.
//

import SwiftUI

@MainActor
@Observable class FirstLevelViewModel: LevelViewModel {
    let moonFrames = ["moon1", "moon2", "moon3", "moon4", "moon5", "moon6"]
    
    override init() {
        super.init()
        setOriginalTokens(tokensFirstLevel_)
        backgroundFrames = ["lv1-background1", "lv1-background2", "lv1-background3", "lv1-background4", "lv1-background5", "lv1-background6"]

    }
    
    func setupDropZones(screenSize: CGSize) {
        let moonDropZone = DropZone(
            name: "Moon",
            position: CGPoint(
                x: screenSize.width * 0.5,
                y: screenSize.height * 0.58
            ),
            size: CGSize(
                width: screenSize.width * 0.5,
                height: screenSize.height * 0.1
            ),
            validQuestions: [
                ["Why", "Does", "The Moon", "Have Phases?"],
                ["Does", "The Moon", "Have Phases?"]
            ]
        )
        
        dropZones = [moonDropZone]
    }
    
}

#Preview(traits: .landscapeLeft) {
    FirstLevelView()
}
