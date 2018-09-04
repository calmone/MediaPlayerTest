//
//  MainVC.swift
//  audioTest
//
//  Created by Taehyeon Han on 2018. 7. 13..
//  Copyright © 2018년 Taehyeon Han. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MainVC: UIViewController {

    var musicPlayer: Player!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(WebVC(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        musicPlayer = Player.shared()
        musicPlayer.prepareAudio()
        musicPlayer.play()
        musicPlayer.playMusicTheraphyTrainingEffectSound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class Player: NSObject, AVAudioPlayerDelegate {
    
    private static var contentsPlayer : Player? = nil
    open class func shared() -> Player {
        if contentsPlayer == nil {
            contentsPlayer = Player()
        }
        return contentsPlayer!
    }
    
    private lazy var audioPlayer = AVAudioPlayer()
    
    override init() {
        super.init()
        makePlayer()
        setupNotifications()
    }
    
    private func makePlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch let e as NSError {
            NSLog("\(e)", e)
        }
    }
    
    func prepareAudio() {
        let fileURL = Bundle.main.url(forResource: "music_theraphy_training", withExtension: ".mp3")
        let currentAudioPath = fileURL
        
        do {
            audioPlayer = try AVAudioPlayer.init(contentsOf: currentAudioPath!)
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = 0
            audioPlayer.prepareToPlay()
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyAlbumTitle: "test",
                MPMediaItemPropertyArtist: "test artist",
                MPNowPlayingInfoPropertyElapsedPlaybackTime: 100.0,
                MPNowPlayingInfoPropertyPlaybackRate: 1
            ]
        } catch let e as NSError {
            NSLog("\(e)", e)
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: .AVAudioSessionInterruption,
                                       object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            // Interruption began, take appropriate actions
            NSLog("%@", "Interruption began, take appropriate actions")
            audioPlayer.pause()
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    NSLog("%@", "Interruption Ended - playback should resume")
                } else {
                    // Interruption Ended - playback should NOT resume
                    NSLog("%@", "Interruption Ended - playback should NOT resume")
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                }
            }
        }
    }
    
    private var soundId: SystemSoundID = 0
    func playMusicTheraphyTrainingEffectSound() {
        if let soundUrl = Bundle.main.url(forResource: "Calm", withExtension: ".mp3") {
            let fileToNSUrl = NSURL(fileURLWithPath: soundUrl.path)
            print("fileCFUrl : \(fileToNSUrl)")
            AudioServicesCreateSystemSoundID(fileToNSUrl, &soundId)
            print("start SystemSound : \(Date())")
//            AudioServicesPlayAlertSoundWithCompletion(soundId) {
//                print("AudioServicesPlaySystemSoundWithCompletion : \(Date())")
//            }
            AudioServicesPlaySystemSoundWithCompletion(soundId) {
                print("AudioServicesPlaySystemSoundWithCompletion : \(Date())")
            }
        }
    }
    
    func stopMusicTheraphyTrainingEffectSound() {
        AudioServicesDisposeSystemSoundID(soundId)
    }
    
}
