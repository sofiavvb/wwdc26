//
//  Token.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 29/01/26.
//

import SwiftUI
import Foundation

struct Token: Identifiable, Hashable, Codable {
    var id = UUID()
    var text: String
    var position: CGPoint = .zero
    var isPlaced: Bool = false
    // ver se terao 3 tipos que serao diferentes visualmente
}

@MainActor var tokensFirstLevel_: [[Token]] = [
    [Token(text: "Does"), Token(text: "The Moon"), Token(text: "Have Phases?"), Token(text: "Why")],
    [Token(text: "Escape?"), Token(text: "Stars?")],
]
