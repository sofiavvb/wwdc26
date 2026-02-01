//
//  FirstLevelViewModel.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 30/01/26.
//

import SwiftUI

@MainActor
@Observable class FirstLevelViewModel: LevelViewModel {
    override init() {
        super.init()
        setOriginalTokens(tokensFirstLevel_)
    }
    
    func setupDropZones(screenSize: CGSize) {
        let moonDropZone = DropZone(
            name: "Moon",
            position: CGPoint(
                x: screenSize.width * 0.5,
                y: screenSize.height * 0.5
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


//
//@MainActor
//@Observable class FirstLevelViewModel {
//    var availableTokens: [[Token]] = tokensFirstLevel_  //tokens in drag area
//    var droppedTokens: [UUID: CGPoint] = [:]
//    var moonDropZone: DropZone?
//    
//    func setupDropZones(screenSize: CGSize) {
//        moonDropZone = DropZone(
//            name: "Moon",
//            position: CGPoint(
//                x: screenSize.width * 0.5,
//                y: screenSize.height * 0.5
//            ),
//            size: CGSize(width: screenSize.width * 0.6, height: screenSize.height * 0.2), //deixar um espaco um pouco maior
//            validQuestions: [
//                ["Why", "Does", "The Moon", "Have Phases?"],
//                ["Does", "The Moon", "Have Phases?"]
//            ]
//        )
//    }
//    
//    func isInAnyDropZone(_ position: CGPoint) -> Bool {
//        guard let moonDropZone = moonDropZone else { return false }
//        return moonDropZone.contains(position)
//    }
//    
//    func isTokenInDropZone(_ token: Token) -> Bool {
//        return droppedTokens[token.id] != nil
//    }
//    
//    func getTokenPosition(_ token: Token) -> CGPoint? {
//        return droppedTokens[token.id]
//    }
//    
//    func moveToDropZone(_ token: Token, at position: CGPoint) {
//        //TODO: ajeitar essa para ele inserir em sequencia os tokens
//        guard let dropZone = moonDropZone else { return }
//        
//        removeFromAvailableTokens(token)
//        
//        droppedTokens[token.id] = CGPoint(
//            x: position.x,
//            y: dropZone.baseline
//        )
//    }
//    
//    func updatePositionInDropZone(_ token: Token, at position: CGPoint) {
//        guard let dropZone = moonDropZone else { return }
//        
//        droppedTokens[token.id] = CGPoint(
//            x: position.x,
//            y: dropZone.baseline
//        )
//    }
//    
//    func moveBackToDragArea(_ token: Token) {
//        droppedTokens.removeValue(forKey: token.id)
//        
//        if availableTokens.isEmpty {
//            availableTokens.append([token])
//        } else {
//            if let index = availableTokens.indices.min(by: {
//                availableTokens[$0].count < availableTokens[$1].count
//            }) {
//                availableTokens[index].append(token)
//            }
//        }
//    }
//    
//    func reset() {
//        droppedTokens.removeAll()
//        availableTokens = tokensFirstLevel_
//    }
//    
//    private func removeFromAvailableTokens(_ token: Token) {
//        for (rowIndex, row) in availableTokens.enumerated() {
//            if let tokenIndex = row.firstIndex(where: { $0.id == token.id }) {
//                availableTokens[rowIndex].remove(at: tokenIndex)
//                return
//            }
//        }
//    }
//}
