//
//  SwiftUIView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 05/02/26.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(SceneManager.self) var sceneManager
    var backgroundFrames = ["welcome1", "welcome2", "welcome3", "welcome4", "welcome5", "welcome6", "welcome7", "welcome8",
                               "welcome9", "welcome10", "welcome11", "welcome12"]
    @State var backgroundFrame: Int = 0
    @State var easterEggFrame: Int = 0
    @State var isAnimating: Bool = false
    var easterEggFrames = ["easterEgg1", "easterEgg2", "easterEgg3", "easterEgg4", "easterEgg5", "easterEgg6", "easterEgg7", "easterEgg8",
                           "easterEgg9", "easterEgg10", "easterEgg11", "easterEgg12", "easterEgg13"]

    var body: some View {
        ZStack{

            TimelineView(.animation(minimumInterval: 0.15)) { timeline in
                Image(backgroundFrames[backgroundFrame])
                    .resizable()
                    .scaledToFill()
                    .onChange(of: timeline.date) { _, _ in
                        backgroundFrame = (backgroundFrame + 1) % backgroundFrames.count
                    }
            }
            
            Button {
                sceneManager.currentScene = .intro
                SoundManager.shared.playSoundEffect(named: "buttonSound")
            } label : {
                Image("startbutton")
                    .resizable()
                    .scaledToFit()
                    .overlay{
                        Text("START")
                            .font(Font.custom(sceneManager.font, size: 30))
                            .foregroundStyle(Color(hex: "#0D201F"))
                    }
                    .frame(width: 200, height: 200)
            }
            VStack{
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()

                HStack{
                    Spacer()
                    Image(easterEggFrames[easterEggFrame])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .padding()
                        .onTapGesture {
                            if isAnimating { return }
                            playEasterEgg()
                        }
                }
                Spacer()
            }

        }.ignoresSafeArea(edges: .all)

    }
    
    func playEasterEgg() {
        Task {
            isAnimating = true
            while easterEggFrame < easterEggFrames.count - 1 {
                easterEggFrame += 1
                try? await Task.sleep(nanoseconds: 0_100_000_000)
            }
            easterEggFrame = 0
            isAnimating = false
        }
        
    }
}

#Preview (traits: .landscapeLeft) {
    let sceneManager: SceneManager = SceneManager()
    WelcomeView()
        .environment(sceneManager)
}
