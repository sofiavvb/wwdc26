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
    var currentFrame = 0
    let componentFrames = ["Component1", "Component2", "Component3", "Component4", "Component5"]

    var progress: Double {
        return Double(completedLevels) / Double(totalLevels)
    }
    
    private init() {}
    
    func completeLevel() {
        completedLevels += 1
    }
    
}
