//
//  SceneManager.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 05/02/26.
//

import SwiftUI

enum SceneType {
    case welcome
    case intro
    case question
    case scientist
    case game
    case aboutMe
    case endGame
    case endScene
}

@MainActor
@Observable final class SceneManager {
    var currentScene: SceneType = .welcome
    var dialogIndex: Int = 0
    var displayedText: String = ""
    var font: String = "Jersey10-Regular"
    private var animationTask: Task<Void, Never>?
    var dialogCompleted: Bool = false
    
    private var fullText: String = ""
    
    var isTextComplete: Bool {
        return displayedText == fullText && !fullText.isEmpty
    }
    
    let dialogs: [SceneType: [String]] = [
        .intro: [
            """
            “The important thing is not to stop\nquestioning. Curiosity has its own\nreason for existence.”
            
            - Albert Einstein
            """,
            "Where can our curiosity takes us?",
            "Since humankind exists, we try to\nunveil the mysteries of reality, of the\nvery universe that surround us.",
            "It is through science that we venture\ntoward the boundaries of what we\nknow. From the wonders of the\nuniverse to our own cells.",
            "At the core of science there is one\nthing: questions."
        ],
        .question: [
            """
            But think about it...
            
            What is the point of an answer if we\ndon’t know the right questions to ask?
            """
        ],
        .scientist: [
            """
            You heard that too, didn’t you? Good. It means you have the power to help me! 
            
            I’m Nova. I travel between galaxies in search of new ideas. 
            """,
            """
            Over the years, I've learned that great questions are often more important than answers.
            
            This is how I built my ship. It is special. Questions can literally shape it. 
            """,
            """
            I am building a supercomputer on it to travel faster, but one component is missing. 
            The problem is I've questioned everything in this quadrant of the galaxy...
            
            Help me build this piece. Fill it with questions.
            """
        ],
        .endGame: [
            "You did it! You created the piece that was missing!",
            "Reflect, discover, question again.",
            "Questions move us forward, they make us think. When knowledge from different fields comes together, innovation begins.",
            """
            Remember: the first step toward changing the world is staying curious and choosing to question.
            """
        ],
    ]
    
    func navigate(to scene: SceneType) {
        self.currentScene = scene
        resetDialog()
        startDialog()
    }
    
    func resetDialog() {
        self.dialogIndex = 0
        self.displayedText = ""
        self.fullText = ""
        self.dialogCompleted = false
        animationTask?.cancel()
    }
    
    func startDialog() {
        guard let dialogs = dialogs[currentScene] else { return }
        animate(dialogs[dialogIndex])
    }
    
    func skip() {
        guard !dialogCompleted else { return }
        guard let texts = dialogs[currentScene] else { return }
        
        if displayedText != fullText {
            animationTask?.cancel()
            displayedText = fullText
        } else {
            dialogIndex += 1
            if dialogIndex < texts.count {
                startDialog()
            } else {
                dialogCompleted = true
            }
        }
    }
    
    func changeFont(to fontName: String){
        self.font = fontName
    }
    
    private func animate(_ text: String){
        displayedText = ""
        animationTask?.cancel()
        fullText = text
        
        animationTask = Task {
            for char in text {
                guard !Task.isCancelled else { return }
                displayedText.append(char)
                try? await Task.sleep(nanoseconds: 50_000_000)
            }
        }
    }
}
