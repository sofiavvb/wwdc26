//
//  SwiftUIView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 05/02/26.
//

import SwiftUI

struct ScientistView: View {
    @State private var backgroundFrame = 0
    @Environment(SceneManager.self) var sceneManager
    private let backgroundFrames = ["BackgroundScientist1", "BackgroundScientist2", "BackgroundScientist3"]
    private let scientistFrames = ["Scientist1", "Scientist2", "Scientist3"]
    private let shipFrames = ["Ship1", "Ship2", "Ship3"]
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1)) { timeline in
                ZStack (alignment: .bottom){
                    // Background
                    Image(backgroundFrames[backgroundFrame])
                        .resizable()
                    
                    if sceneManager.dialogIndex == 2 {
                        Image("Component1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 1.2, height: geometry.size.height * 1.2)
                            .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.38)
                            .background(.black.opacity(0.55))
                    } else {
                        Image(shipFrames[backgroundFrame])
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                            .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.38)
                    }
                    
                    HStack(alignment: .bottom) {
                        Image(scientistFrames[backgroundFrame])
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.45)
                            .offset(x: 8)
                                                
                        DialogBox(geometry: geometry)
                    }
                }
                .onChange(of: timeline.date) {
                    backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
                }
                .onChange(of: sceneManager.dialogCompleted) {
                    sceneManager.navigate(to: .game)
                }
                .ignoresSafeArea(.all)
                .onTapGesture {
                    sceneManager.skip()
                }
            }
        }
    }
}

struct DialogBox: View {
    @Environment(SceneManager.self) var sceneManager
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Image("DialogBox")
                .resizable()
                .scaledToFit()
            
            Text(sceneManager.displayedText)
                .font(Font.custom("Jersey10-Regular", size: 45))
                .foregroundColor(.white)
                .frame(
                    width: geometry.size.width * 0.68,
                    alignment: .topLeading
                )
        }
    }
}

#Preview(traits: .landscapeLeft) {
    let sceneManager: SceneManager = SceneManager()
    ScientistView()
        .environment(sceneManager)
}
