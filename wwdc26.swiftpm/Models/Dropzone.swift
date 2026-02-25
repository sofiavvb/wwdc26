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
    let position: CGPoint
    let size: CGSize 
    let validQuestions: [[String]]
    var tokens: [UUID: CGPoint] = [:]
    let minTokenSpacing: CGFloat = 65
    
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
    
    // get the right x coordinate for the token (avoiding overlapping and some margins hehe)
    mutating func findValidPosition(tokenId: UUID, at droppedPosition: CGPoint) -> CGPoint {
        var xCoordinate = droppedPosition.x
        var attempts = 0
        
        // get all other tokens of the dropzone
        let otherTokens = tokens.filter { $0.key != tokenId }
        
        while attempts < 10 {
            var hasCollision = false
            
            for (_, position) in otherTokens {
                let distance = abs(xCoordinate - position.x)
                
                print(distance)
                if distance < minTokenSpacing {
                    print("colidiu")
                    hasCollision = true
                    xCoordinate = position.x + minTokenSpacing + 60
                    break
                }
            }
            
            // making sure it does not go out of the bounds of dropzone
            if !hasCollision {
                let leftBound = frame.minX + 60
                let rightBound = frame.maxX - 60
                print(leftBound)
                print(rightBound)
                if xCoordinate < leftBound {
                    xCoordinate = leftBound
                } else if xCoordinate > rightBound {
                    xCoordinate = rightBound
                }
                break
            }

            attempts += 1
        }
        
        return CGPoint(x: xCoordinate, y: baseline)
        
    }
    
    mutating func addToken(_ token: Token, at position: CGPoint) {
        let tokenId = token.id
        let finalPosition = findValidPosition(tokenId: tokenId, at: position)
        tokens[tokenId] = finalPosition
    }
    
    mutating func removeToken(_ token: Token) {
        let tokenId = token.id
        tokens.removeValue(forKey: tokenId)
    }
    
    mutating func updateTokenPosition(_ token: Token, at position: CGPoint) {
        let tokenId = token.id
        let finalPosition = findValidPosition(tokenId: tokenId, at: position)
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
