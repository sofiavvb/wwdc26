//
//  HologramMenu.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 11/02/26.
//

import SwiftUI

struct HologramMenu: View {
    @Environment(SceneManager.self) var sceneManager
    @State private var isExpanded = true
    @Bindable var vm: LevelViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                ZStack(alignment: .trailing) {
                    Button {
                        withAnimation(.spring()) {
                            isExpanded.toggle()
                        }
                    } label: {
                        if (isExpanded){
                            Image("expandedMenu")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }else{
                            Image("collapsedMenu")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .offset(x: 50)
                        }
                    }
                    
                    if isExpanded {
                        VStack(spacing: 20) {
                            Button() {
                                vm.hint()
                            } label: {
                                Image("ButtonGame")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 50)
                                    .overlay {
                                        buttonText(text: "SOLVE", font: sceneManager.font, acessibilityLabel: "Solve one dropzone")
                                    }
                            }.disabled(vm.isHinting)
                            
                            Button {
                                vm.reset()
                            } label: {
                                Image("ButtonGame")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 50)
                                    .overlay{
                                        buttonText(text: "RESET", font: sceneManager.font, acessibilityLabel: "Reset available tokens to drag area.")
                                    }
                            }
                        }
                        .padding(.trailing, 15)
                    }                
                }
            }
            Spacer()
        }
    }
}

struct buttonText: View {
    var text: String
    var font: String
    var acessibilityLabel: String
    
    var body: some View {
        Text(text)
            .font(Font.custom(font, size: 32))
            .bold()
            .accessibilityLabel(acessibilityLabel)
            .foregroundStyle(Color.black)
    }
}

