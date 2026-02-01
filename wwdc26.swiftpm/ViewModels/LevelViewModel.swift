import SwiftUI

@MainActor
@Observable class LevelViewModel {
    var availableTokens: [[Token]] = []
    var dropZones: [DropZone] = []
    var completedZones: Set<UUID> = []
    var isLevelComplete = false
    var showCelebration = false
    private var allTokens: [Token] = []
    
    func setOriginalTokens(_ tokens: [[Token]]) {
        self.availableTokens = tokens
        self.allTokens = tokens.flatMap { $0 }
    }
    
    func getDropZone(at position: CGPoint) -> DropZone? {
        return dropZones.first { $0.contains(position) }
    }
    
    func getDropZone(containing tokenId: UUID) -> DropZone? {
        return dropZones.first { $0.tokens.keys.contains(tokenId) }
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
        removeFromAvailableTokens(token)
        
        if let index = dropZones.firstIndex(where: { $0.id == dropZone.id }) {
            dropZones[index].addToken(token, at: position)
            print(dropZones[index])
            //se eu passo so a dropZone ela nao ta certa, pois eh uma copia != da que eu acabei de adicionar o token
            checkQuestion(for: dropZones[index])
        }
    }
    
    func updatePositionInDropZone(_ token: Token, at position: CGPoint) {
        if let zoneIndex = dropZones.firstIndex(where: { $0.tokens.keys.contains(token.id) }) {
            dropZones[zoneIndex].updateTokenPosition(token, at: position)
            checkQuestion(for: dropZones[zoneIndex])
        }
    }
    
    func checkQuestion(for dropZone: DropZone){
        guard !completedZones.contains(dropZone.id) else { return }
        if validateDropZone(dropZone) {
            print("Valid question completed in \(dropZone.name)!")
            
            completedZones.insert(dropZone.id)
            
            showCelebration = true
            
            // TODO: Play sound
            
            if completedZones.count == dropZones.count {
                handleLevelComplete()
            }
            
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                showCelebration = false
            }
        }
    }
    
    func moveBackToDragArea(_ token: Token) {
        // TODO:  ver isso (Remove from all drop zones)
        for index in dropZones.indices {
            dropZones[index].removeToken(token)
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
        print("Tokens ordenados: \(orderedTokens)")
        let textArray = orderedTokens.map { $0.text }
        print("Texto do array: \(textArray)")
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
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
