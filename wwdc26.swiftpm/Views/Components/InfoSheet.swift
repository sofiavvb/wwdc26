//
//  InfoSheet.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 19/02/26.
//

import SwiftUI

struct InfoSheet: View {
    @Environment(SceneManager.self) var sceneManager
    var vm: FirstLevelViewModel
    var proxy: GeometryProxy
    
    var body: some View {
        
        Color.black.opacity(0.7)
            .ignoresSafeArea()
            .transition(.opacity)
        
        Image("modal")
            .resizable()
            .scaledToFit()
            .overlay {
                VStack (spacing: 0){
                    Text("""
                         Multiple questions can move you further. There is not a single possible path...
                         If needed, use the top trailing menu for help ;)
                         """)
                    .font(Font.custom(sceneManager.font, size: 32))
                    .foregroundStyle(.white)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Button {
                        vm.isShowingSheet.toggle()
                    } label: {
                        Image("dismissButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 85)
                            .overlay {
                                Text("OK")
                                    .font(Font.custom(sceneManager.font, size: 25))
                                    .foregroundStyle(Color(hex: "#0D201F"))
                            }
                    }
                }
                .padding()
            }
            .frame(maxWidth: proxy.size.width * 0.6, maxHeight: proxy.size.height * 0.9)
           .transition(.scale)
        
    }
}

