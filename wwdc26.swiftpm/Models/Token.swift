//
//  Token.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 29/01/26.
//

import SwiftUI

struct Token: Identifiable, Hashable, Codable {
    var id = UUID()
    var text: String
    var background: String
}

//TODO: deixar isso centralizado melhor, me parece meio gambiarrento oq eu fiz

@MainActor var tokensFirstLevel_: [[Token]] = [
    [Token(text: "Does", background: "token-azul"),
     Token(text: "The Moon", background: "token-verde"),
     Token(text: "Have Phases?", background: "token-amarelo"),
     Token(text: "Why", background: "token-azul")],
    [Token(text: "Escape?", background: "token-amarelo"),
     Token(text: "Stars", background: "token-verde")],
]

@MainActor var tokensSecondLevel_: [[Token]] = [
    [Token(text: "Why", background: "token-azul"),
     Token(text: "The Earth", background: "token-verde"),
     Token(text: "What", background: "token-azul"),
     Token(text: "Rotate?", background: "token-amarelo"),
     Token(text: "Travelling?", background: "token-amarelo"),
     Token(text: "The Rings", background: "token-verde")],
    [Token(text: "Is", background: "token-azul"),
     Token(text: "How", background: "token-azul"),
     Token(text: "Made of?", background: "token-amarelo"),
     Token(text: "Are", background: "token-azul"),
     Token(text: "Comets", background: "token-verde"),
     Token(text: "Does", background: "token-azul"),
     Token(text: "Are", background: "token-azul")],
]
