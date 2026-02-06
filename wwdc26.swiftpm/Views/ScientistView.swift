//
//  SwiftUIView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 05/02/26.
//

import SwiftUI

struct ScientistView: View {
    @State private var backgroundFrame = 0
    private let backgroundFrames = ["Cientista+fundo1", "Cientista+fundo2", "Cientista+fundo3"]
    
    var body: some View {
        ZStack {
            //background
            TimelineView(.animation(minimumInterval: 1)) { timeline in
                Image(backgroundFrames[backgroundFrame])
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .onChange(of: timeline.date) { _, _ in
                        backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
                    }
            }
            //nave ou componente
            
            //dialog box
        }
    }
}
