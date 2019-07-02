//
//  SecondViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/9/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet var playerView: YTPlayerView!
    var video = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .defaultToSpeaker)
        } catch let error {
            print("Error: \(error)")
        }
        playerView.load(withVideoId: video)
    }

    //Third party videos no youtube
    /*
     let videoURL = URL(string: "https://twitter.com/zlebmada/status/1127958141641969666/video/1")
     let player = AVPlayer(url: videoURL!)
     let playerViewController = AVPlayerViewController()
     playerViewController.player = player
     self.present(playerViewController, animated: true) {
     playerViewController.player!.play()
     */

}

