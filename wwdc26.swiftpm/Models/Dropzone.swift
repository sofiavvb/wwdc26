//
//  Dropzone.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 30/01/26.
//

import SwiftUI

struct DropZone: Identifiable {
    let id: UUID = UUID()
    let name: String
    let position: CGPoint //center position on screen
    let size: CGSize //width and height of the drop zone
    let validQuestions: [[String]]
    var tokens: [UUID: CGPoint] = [:]  //tokenId -> position in this zone
    
    var frame: CGRect {
        CGRect(
            x: position.x - size.width / 2,
            y: position.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
    
    var baseline: CGFloat {
        position.y
    }
    
    func contains(_ point: CGPoint) -> Bool {
        frame.contains(point)
    }
    
    mutating func addToken(_ token: Token, at position: CGPoint) {
        let tokenId = token.id
        let finalPosition = CGPoint(x: position.x, y: baseline)
        tokens[tokenId] = finalPosition
    }
    
    mutating func removeToken(_ token: Token) {
        let tokenId = token.id
        tokens.removeValue(forKey: tokenId)
    }
    
    mutating func updateTokenPosition(_ token: Token, at position: CGPoint) {
        let tokenId = token.id
        let finalPosition = CGPoint(x: position.x, y: baseline)
        tokens[tokenId] = finalPosition
    }
    
    func getOrderedTokens(from allTokens: [Token]) -> [Token] {
        return tokens
            .sorted { $0.value.x < $1.value.x }
            .compactMap { tokenId, _ in
                allTokens.first(where: { $0.id == tokenId })
            }
    }
}
