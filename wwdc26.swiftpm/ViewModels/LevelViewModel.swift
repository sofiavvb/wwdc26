import SwiftUI

@MainActor
@Observable class LevelViewModel {
    var availableTokens: [[Token]] = []
    var dropZones: [DropZone] = []
    var completedZones: Set<UUID> = []
    var isLevelComplete = false
    var showCelebration = false
    var backgroundFrame: Int = 0
    var backgroundFrames: [String] = []
    private var allTokens: [Token] = []
    
    func setOriginalTokens(_ tokens: [[Token]]) {
        self.availableTokens = tokens
        self.allTokens = tokens.flatMap { $0 }
    }
    
    func getDropZone(at position: CGPoint) -> DropZone? {
        return dropZones.first { zone in
            zone.contains(position) && !completedZones.contains(zone.id)
        }
    }
    
    func getTokenPosition(for token: Token) -> CGPoint? {
        for dropZone in dropZones {
            if let position = dropZone.tokens[token.id] {
                return position
            }
        }
        return nil
    }
    
    func moveToDropZone(_ token: Token, dropZone: DropZone, at position: CGPoint) {
        // if is in a dropzone already
        if let currentZoneIndex = dropZones.firstIndex(where: { $0.tokens.keys.contains(token.id) }) {
            // might be moving within or to another zone
            let currentZoneId = dropZones[currentZoneIndex].id
            
            //same zone (update position)
            if dropZone.id == currentZoneId {
                dropZones[currentZoneIndex].updateTokenPosition(token, at: position)
                checkQuestion(for: dropZones[currentZoneIndex])
            } else {
                guard let targetZoneIndex = dropZones.firstIndex(where: { $0.id == dropZone.id }) else { return }
                
                dropZones[currentZoneIndex].removeToken(token)
                checkQuestion(for: dropZones[currentZoneIndex])
                
                dropZones[targetZoneIndex].addToken(token, at: position)
                checkQuestion(for: dropZones[targetZoneIndex])
            }
            // from drag area
        } else {
            if let targetZoneIdx = dropZones.firstIndex(where: { $0.id == dropZone.id }) {
                removeFromAvailableTokens(token)
                dropZones[targetZoneIdx].addToken(token, at: position)
                checkQuestion(for: dropZones[targetZoneIdx])
            }
        }
    }
    
    func checkQuestion(for dropZone: DropZone){
        guard !completedZones.contains(dropZone.id) else { return }
        if validateDropZone(dropZone) {
            completedZones.insert(dropZone.id)
            showCelebration = true
            SoundManager.shared.playSoundEffect(named: "questionSucess")
            GameManager.shared.currentFrame += 1
            
            if completedZones.count == dropZones.count {
                handleLevelComplete()
            }
            
            Task {
                try? await Task.sleep(nanoseconds: 0_500_000_000)
                showCelebration = false
            }
        }
    }
    
    func moveBackToDragArea(_ token: Token) {
        // TODO:  ver isso (Remove from all drop zones)
        for index in dropZones.indices {
            dropZones[index].removeToken(token)
            checkQuestion(for: dropZones[index])
        }
        
        if availableTokens.isEmpty {
            availableTokens.append([token])
        } else {
            if let index = availableTokens.indices.min(by: {
                availableTokens[$0].count < availableTokens[$1].count
            }) {
                availableTokens[index].append(token)
            }
        }
        
    }
    
    func validateDropZone(_ dropZone: DropZone) -> Bool {
        let orderedTokens = dropZone.getOrderedTokens(from: allTokens)
        let textArray = orderedTokens.map { $0.text }
        print(textArray)
        return dropZone.validQuestions.contains(textArray)
    }
    
    func reset() {
        for index in dropZones.indices {
            dropZones[index].tokens.removeAll()
        }
        availableTokens = allTokens.chunked(into: 4) //TODO: rever isso
    }
    
    private func removeFromAvailableTokens(_ token: Token) {
        for (rowIndex, row) in availableTokens.enumerated() {
            if let tokenIndex = row.firstIndex(where: { $0.id == token.id }) {
                availableTokens[rowIndex].remove(at: tokenIndex)
                return
            }
        }
    }
    
    private func handleLevelComplete() {
        isLevelComplete = true
        
        GameManager.shared.completeLevel()
        
        print("Level complete! Global progress: \(GameManager.shared.progress)")
    }
    
    func updateBackgroundFrame() {
        backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
    }
}
