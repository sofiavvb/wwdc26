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
    var isHinting: Bool = false
    var isDragging: Bool = false
    var selectedToken: Token? = nil
    var incorrectTokensIds: Set<UUID> = []
    private var allTokens: [Token] = []
    
    func setOriginalTokens(_ tokens: [[Token]]) {
        self.availableTokens = tokens
        self.allTokens = tokens.flatMap(\.self)
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
//        if !checkCompatibility(token, with: dropZone) {
//            incorrectTokensIds.insert(token.id)
//            SoundManager.shared.playSoundEffect(named: "error")
//            
//            Task {
//                    try? await Task.sleep(nanoseconds: 600_000_000)
//                    incorrectTokensIds.remove(token.id)
//                    moveBackToDragArea(token)
//            }
//        }
        
        // if is in a dropzone already
        if let currentZoneIndex = dropZones.firstIndex(where: { $0.tokens.keys.contains(token.id) }) {
            
            let currentZoneId = dropZones[currentZoneIndex].id
            
            // same zone
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
            SoundManager.shared.playSoundEffect(named: "sucess")
            GameManager.shared.currentFrame += 1
            
            if completedZones.count == dropZones.count {
                handleLevelComplete()
            }
            
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                showCelebration = false
            }
        }
    }
    
    func moveBackToDragArea(_ token: Token) {
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
        return dropZone.validQuestions.contains(textArray)
    }
    
    func reset() {
        var tokensToAdd: [Token] = []
        var tokensReseted: [Token] = availableTokens.flatMap(\.self)
        
        for index in dropZones.indices {
            // cant reset tokens already locked
            if completedZones.contains(dropZones[index].id) { continue }
            
            tokensToAdd = allTokens.filter {
                dropZones[index].tokens.keys.contains($0.id)
            }
            
            for token in tokensToAdd {
                tokensReseted.append(token)
            }
            dropZones[index].tokens.removeAll()
        }
        availableTokens = tokensReseted.chunked(into: 7)
    }
    
    func hint() {
        let incompleteZones = dropZones.filter { !completedZones.contains($0.id) }
        var chosenZone: DropZone? = nil
        var questionsToChoose: [[String]] = []
        
        isHinting.toggle()
        
        guard !incompleteZones.isEmpty else {
            print("todas as zonas preenchidas")
            return
        }
        
        // transform them in a single list
        let availableTokensConcatened = availableTokens.flatMap(\.self)
        var availableTokensIds = Set(availableTokensConcatened.map(\.id))
        
        // add the id's of tokens in incompleted zones (not in drag area)
        for incompleteZone in incompleteZones {
            for tokenId in incompleteZone.tokens.keys {
                availableTokensIds.insert(tokenId)
            }
        }
        
        // choose zone (the one with less tokens, maybe i will change)
        chooseZone(incompleteZones, availableTokensIds, &chosenZone, &questionsToChoose)
        
        guard let zone = chosenZone else {
            print("nao tem solvable zone")
            return
        }
        
        // choose question considerating the tokens the user already placed
        guard let selectedQuestion = chooseQuestion(from: questionsToChoose, in: zone, availableTokenIds: availableTokensIds) else {
            print("tem nao")
            return
        }
        
        print("Pergunta escolhida: \(selectedQuestion)")
        var tokenIdsToMove: [UUID] = []
        
        for word in selectedQuestion {
            if let token = allTokens.first(where: {
                $0.text == word &&
                availableTokensIds.contains($0.id)
            }) {
                tokenIdsToMove.append(token.id)
            }
        }
        
        solve(zone: zone, tokenIds: tokenIdsToMove)
        
    }
    
    private func chooseZone(_ incompleteZones: [DropZone], _ availableTokensIds: Set<UUID>, _ chosenZone: inout DropZone?, _ questionsToChoose: inout [[String]]) {
        
        for zone in incompleteZones {
            let availableQuestions = zone.validQuestions.filter { question in
                question.allSatisfy { word in
                    allTokens.contains { token in
                        token.text == word &&
                        availableTokensIds.contains(token.id)
                    }
                }
            }
            
            if availableQuestions.isEmpty {
                continue
            }
            
            if chosenZone == nil {
                chosenZone = zone
                questionsToChoose = availableQuestions
            }else if (zone.tokens.keys.count < chosenZone!.tokens.keys.count){
                chosenZone = zone
                questionsToChoose = availableQuestions
            }
        }
    }
    
    private func chooseQuestion(from questions: [[String]], in zone: DropZone, availableTokenIds: Set<UUID>) -> [String]? {
        var bestQuestion: [String]? = nil
        var bestScore = -1
        let placedWords = zone.tokens.keys.compactMap { id in
            allTokens.first(where: { $0.id == id })?.text
        }
        
        for question in questions {
            
            let score = question.filter { word in
                placedWords.contains(word)
            }.count
            
            if score > bestScore {
                bestScore = score
                bestQuestion = question
            }
        }
        
        return bestQuestion
    }
    
    private func solve(zone: DropZone, tokenIds: [UUID]) {
        Task {
            guard let zoneIndex = dropZones.firstIndex(where: { $0.id == zone.id }) else { return }
            
            let tokensInZone = Set(dropZones[zoneIndex].tokens.keys)
            
            // clean the zone
            for tokenId in tokensInZone {
                if let token = allTokens.first(where: { $0.id == tokenId }) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        moveBackToDragArea(token)
                    }
                    try? await Task.sleep(nanoseconds: 150_000_000)
                }
            }
            
            let startX = zone.position.x - zone.frame.width / 2
            var currentX = startX
            
            for (_, tokenId) in tokenIds.enumerated() {
                guard let token = allTokens.first(where: { $0.id == tokenId }) else { continue }
                
                let position = CGPoint(
                    x: currentX + token.getTokenWidth() / 2,
                    y: zone.baseline
                )
                
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    moveToDropZone(token, dropZone: zone, at: position)
                }
                
                currentX += token.getTokenWidth() + 12

                try? await Task.sleep(nanoseconds: 400_000_000)
            }
            isHinting.toggle()
        }
    }
    
    func checkCompatibility(_ token: Token, with dropZone: DropZone) -> Bool {
        return dropZone.validQuestions.contains { question in
            question.contains(token.text)
        }
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
    }
    
    func updateBackgroundFrame() {
        backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
    }
}
