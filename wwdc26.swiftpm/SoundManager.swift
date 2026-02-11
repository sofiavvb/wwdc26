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
    private var soundEffectPlayer: AVAudioPlayer?
    private var musicPlayer: AVAudioPlayer?
    
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
    
    func playMusic(named musicName: String, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: musicName, withExtension: "mp3") else {
            return
        }
        
        if musicPlayer?.url == url, musicPlayer?.isPlaying == true {
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = loop ? -1 : 0
            musicPlayer?.volume = 0.2
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
