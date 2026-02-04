//
//  SoundManager.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 02/02/26.
//

import SwiftUI
import AVFoundation

@MainActor
@Observable class SoundManager {
    static let shared = SoundManager()
    var soundEffectPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSoundEffect(named soundName: String) {
        guard let path = Bundle.main.path(forResource: "\(soundName)", ofType: "mp3") else {
            print("Sound effect \(soundName) not found :( ")
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = 0.4
            soundEffectPlayer?.play()
            
        } catch {
            print("Error playing sound effect \(soundName): \(error.localizedDescription)")
        }
    }
}
