//
//  FeedViewCell.swift
//  TJournalGifv
//
//  Created by christina on 02.05.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import UIKit
import AVFoundation

class FeedViewCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postView: UIView!
    
    let videoPlayerView = VideoPlayerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 9 Add player
    @objc private let player = AVQueuePlayer()
    private var token: NSKeyValueObservation?

    /*init(clips: [VideoClip]) {
      self.clips = clips
      
      super.init(frame: .zero)
      
      // 10 Set up the player
      //initializePlayer()
      //addGestureRecognizers()
    }*/
    
    // 10 Set up player
    /*private func initializePlayer() {
      videoPlayerView.player = player
      
      addAllVideosToPlayer()

      player.volume = 0.0
      player.play()
      
      token = player.observe(\.currentItem) { [weak self] player, _ in
        if player.items().count == 1 {
          self?.addAllVideosToPlayer()
        }
      }
    }*/
    
    
    // 12 Add methods to pause and play when the view leaves the screen
    func pause() {
      player.pause()
    }

    func play() {
      player.play()
    }
    
}
