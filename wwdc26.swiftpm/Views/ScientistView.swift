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
                    
                    Button {
                        sceneManager.skip()
                    } label : {
                        Image("skipbutton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .scaleEffect(sceneManager.isTextComplete ? 1.13 : 1.0, anchor: .center)
                            .shadow(
                                color: sceneManager.isTextComplete ? .teal.opacity(0.5) : .clear,
                                radius: sceneManager.isTextComplete ? 10 : 0
                            )
                            .animation(
                                sceneManager.isTextComplete
                                ? .smooth(duration: 0.8).repeatForever(autoreverses: true)
                                : .default,
                                value: sceneManager.isTextComplete
                            )
                    }
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.95)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 45)

                }
                .onChange(of: timeline.date) {
                    backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
                }
                .onChange(of: sceneManager.dialogCompleted) {
                    sceneManager.navigate(to: .game)
                }
                .ignoresSafeArea(.all)
            }
        }
    }
}

struct DialogBox: View {
    @Environment(SceneManager.self) var sceneManager
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack() {
            Image("DialogBox")
                .resizable()
                .scaledToFit()
            
            Text(sceneManager.displayedText)
                .font(Font.custom("Jersey10-Regular", size: 40))
                .foregroundColor(.white)
                .padding(.trailing, 30)
                .padding(.vertical, 10)
                .frame(
                    width: geometry.size.width * 0.64,
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
