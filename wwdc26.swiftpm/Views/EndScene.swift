//
//  SwiftUIView.swift
//  Before the Answer
//
//  Created by Sofia Villas Bôas on 10/02/26.
//

import SwiftUI

struct EndScene: View {
    @Environment(SceneManager.self) var sceneManager
    @State private var opacity: Double = 1
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Text("Just like you did.")
                    .font(Font.custom("Jersey10-Regular", size: 75))
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .frame(maxWidth: .infinity, maxHeight: 800)
                    .padding(.horizontal, 70)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)   {
                    withAnimation(.easeOut(duration: 1)) {
                        opacity = 0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        sceneManager.navigate(to: .welcome)
                    }
                }
            }
            
        }
    }
}
