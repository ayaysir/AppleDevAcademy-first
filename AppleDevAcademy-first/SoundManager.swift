//
//  SoundManager.swift
//  AppleDevAcademy-first
//
//  Created by 윤범태 on 2023/03/12.
//

import AVFoundation
import MediaPlayer

class SoundManager {
    
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    var isPlaying: Bool {
        guard let player = player else {
            return false
        }
        
        return player.isPlaying
    }
    
    func addMediaToCommandCenter(_ metadata: MediaMetadata) {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            guard let player = player else {
                return .commandFailed
            }
            
            if player.rate == 0.0 || player.duration != 0.0 {
                player.play()
                return .success
            }
            
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            guard let player = player else {
                return .commandFailed
            }
            
            if player.rate == 1.0 {
                player.pause()
                return .success
            }
            
            return .commandFailed
        }
        
        // CommandCenter Information
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
        
        // Image
        if let image = metadata.albumArtImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func readyAndStart(_ metadata: MediaMetadata, fileType: AVFileType = .mp3) {
        
        // forResource: 파일 이름(확장자 제외) , withExtension: 확장자(mp3, wav 등) 입력
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let url = metadata.mediaFileURL
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: fileType.rawValue)
            guard let player = player else {
                print("player is nil")
                return
            }
            player.numberOfLoops = -1
            player.play()
            addMediaToCommandCenter(metadata)
            
            print("now playing...")
        } catch let error {
            print("SoundManager Error:", error.localizedDescription)
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }

    func stop() {
        player?.stop()
    }
}


