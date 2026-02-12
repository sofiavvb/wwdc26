//
//  EndGameView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 10/02/26.
//

import SwiftUI

struct EndGameView: View {
    @Environment(SceneManager.self) var sceneManager
    @State private var backgroundFrame = 0
    @State private var scientistFrame = 0
    private let backgroundFrames = ["backgroundFinal1", "backgroundFinal2", "backgroundFinal3", "backgroundFinal4", "backgroundFinal5", "backgroundFinal6"]
    private let scientistFrames = ["scientistZoomed1", "scientistZoomed2"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TimelineView(.animation(minimumInterval: 2)) { timeline in
                    Image(backgroundFrames[backgroundFrame])
                        .resizable()
                        .ignoresSafeArea()
                        .onChange(of: timeline.date) { _, _ in
                            backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
                        }
                }
                Image("visor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.45)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.35)
                    .overlay {
                        VStack {
                            Image("Component5")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width , height: geometry.size.height )
                                .position(x: geometry.size.width * 0.52, y: geometry.size.height * 0.3)
                        }
                    }
                
                VStack (alignment: .leading){
                    Spacer()
                    ZStack {
                        Image("dialogFinal")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 130)
                        
                        HStack() {
                            TimelineView(.animation(minimumInterval: 0.9)) { timeline in
                                Image(scientistFrames[scientistFrame])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 180, maxHeight: 180)
                                    .offset(x: 25)
                                    .onChange(of: timeline.date) { _, _ in
                                        scientistFrame = (scientistFrame + 1) % scientistFrames.count
                                    }
                            }
                            Spacer()
                            Text(sceneManager.displayedText)
                                .font(Font.custom("Jersey10-Regular", size: 40))
                                .foregroundColor(.white)
                                
                                .padding(.vertical, 10)
                                .frame(
                                    width: geometry.size.width * 0.64,
                                    alignment: .topLeading
                                ).offset(x: -120)
                        }
                    }
                    
                }.ignoresSafeArea()

                Button {
                    sceneManager.skip()
                } label : {
                    Image("skipbutton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
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
                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9)
                .padding(.horizontal, 60)
                .padding(.vertical, 45)
            }
        }.onChange(of: sceneManager.dialogCompleted) {
            sceneManager.navigate(to: .endScene)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    let sceneManager: SceneManager = SceneManager()
    EndGameView().environment(sceneManager)
}
