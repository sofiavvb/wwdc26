//
//  GameManager.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 31/01/26.
//


import SwiftUI

@MainActor
@Observable class GameManager {
    static let shared = GameManager()
    var completedLevels: Int = 0
    let totalLevels = 2
    var currentFrame: String? = nil
    let level1AnimationFrames = ["PassarFala1", "PassarFala2"]
    let level2AnimationFrames = ["PassarFala1", "PassarFala2"]
    
    var progress: Double {
        return Double(completedLevels) / Double(totalLevels)
    }
    
    var consoleMessage: String {
        if completedLevels == 0 {
            return "Look around... Explore. Just like in life, here a question can move us forward!"
        } else if completedLevels == 1 {
            return "Great! Every great creation start like this. Keep going!"
        } else {
            return "You did it!"
        }
    }
    
    func completeLevel() {
        completedLevels += 1
        
        switch completedLevels {
            case 1:
                currentFrame = "progress_50"
            case 2:
                currentFrame = "progress_100"
            default:
                break
        }
    }
    
    func reset() {
        completedLevels = 0
    }
}
