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
    private var musicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSoundEffect(named soundName: String) {
        guard let path = Bundle.main.path(forResource: "\(soundName)", ofType: "mp3") else {
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = 0.45
            soundEffectPlayer?.play()
            
        } catch {
            print("error playing \(soundName): \(error.localizedDescription)")
        }
    }
    
    func playMusic(named name: String, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }
        
        if musicPlayer?.url == url, musicPlayer?.isPlaying == true {
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.volume = 0.2
            musicPlayer?.numberOfLoops = loop ? -1 : 0
            musicPlayer?.play()
        } catch {
            print("error playing music: \(error)")
        }
    }
    
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
}
