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
    
    let player = AVPlayer()
    
    //let videoPlayerView = VideoPlayerView()
    //var post: PostModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //configure(with: .none)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var contentType: VideoType = .gif
    
    func configure(with item: DataResult?) {
        if let item = item {
            let urlString = item.cover.url
            print(item.cover.additionalData.type)
            contentType = item.cover.additionalData.type
            //contentURL = URL(string: urlString)
            //title.text = contentItem.intro
            //title.alpha = 1
        } else {
            //title.alpha = 0
            //contentURL = nil
        }
    }
    
    /*func configure(with post: DataResult) {
        print(post)
      if let post = post {
        switch post.type {
        case VideoType.jpg:
            pasteImage(url: post.video_url)
        case VideoType.gif:
            pasteVideo(url:  post.video_url)
        break
        }
        postTitle.text = post.name
        
        postTitle?.text = post.name
        //reputationLabel?.text = post.reputation
        //displayNameLabel.alpha = 1
        //reputationContainerView.alpha = 1
      } else {
        //displayNameLabel.alpha = 0
        //reputationContainerView.alpha = 0
      }
    }*/
    
    func configure(post: PostModel) {
        switch post.type {
        case VideoType.jpg:
            pasteImage(url: post.video_url)
        case VideoType.gif:
            pasteVideo(url:  post.video_url)
        break
        }
        print(post.type)
        print(post.video_url)
        postTitle.text = post.name
        
        
        //player = AVPlayer(url: post.video_url)
        //let playerLayer = AVPlayerLayer(player: player)
        
       /* let avPlayer = AVPlayer(url: post.video_url)
        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = postView.frame
        
        
        //playerLayer.frame = postView.bounds
        
        postView.layer.addSublayer(avPlayerLayer)*/
    }
    
    func pasteImage(url: URL) {
        let postImage: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleToFill
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        let imageConstraints: [NSLayoutConstraint] = [
            postImage.rightAnchor.constraint(equalTo: postView.rightAnchor, constant: 0),
            postImage.leftAnchor.constraint(equalTo: postView.leftAnchor, constant: 0),
            postImage.topAnchor.constraint(equalTo: postView.topAnchor, constant: 0),
            postImage.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: 0)
        ]
        postImage.load(url: url)
        
        postView.addSubview(postImage)
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    func pasteVideo(url: URL) {
        let avPlayer = AVPlayer(url: url)
        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = postView.frame
        postView.layer.addSublayer(avPlayerLayer)
    }
    
    // 9 Add player
    //@objc private let player = AVQueuePlayer()
    //private var token: NSKeyValueObservation?

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
