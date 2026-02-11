//
//  HologramMenu.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 11/02/26.
//

import SwiftUI

struct HologramMenu: View {
    @State private var isExpanded = false
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
                            Button {
                                vm.hint()
                            } label: {
                                Image("hintButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 50)
                            }
                            
                            Button {
                                vm.reset()
                            } label: {
                                Image("resetButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 50)
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
