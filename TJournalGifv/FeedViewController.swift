//
//  FeedViewController.swift
//  TJournalGifv
//
//  Created by christina on 29.04.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FeedViewController: UIViewController {
    
    @IBOutlet weak var subsiteTitle: UILabel!
    @IBOutlet weak var subsiteDescription: UILabel!
    @IBOutlet weak var subsiteImage: UIImageView!
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var photoManager = RequestManager()
    var photos: [PhotoModel] = []
    
    //1
    //let video = videos[indexPath.row]

    //2
    //let videoURL = video.url
    //let videoURL = URL(string: "https://www.youtube.com/watch?v=zsc-S3-b1YU")
    let player = AVPlayer(url: URL(string: "https://www.youtube.com/watch?v=zsc-S3-b1YU")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        feedTableView.register(UINib(nibName: "FeedViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        //feedTableView.register(FeedViewCell.self, forCellReuseIdentifier: "PostCell")
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        
        //photoManager.delegate = self
        photoManager.fetchPhotos()
    }


}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("sdfsdf")
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedViewCell
        
        let videoURL = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        //let videoURL = URL(string: "https://www.youtube.com/watch?v=zsc-S3-b1YU")
        let player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cell.bounds
        
        cell.layer.addSublayer(playerLayer)
        cell.postView.layer.addSublayer(playerLayer)
        //cell.playerView?.layer.addSublayer(playerLayer)
        //player.play()
        
        /*let cell: FeedCell = tableView.dequeueReusableCellWithIdentifier("VedioCell", forIndexPath: indexPath) as! FeedCell

        let videoURL = NSURL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(URL: videoURL!)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cell.bounds

        cell.layer.addSublayer(playerLayer)
        cell?.playerView?.layer.addSublayer(playerLayer)
        player.play()

        return cell*/
        
        
        cell.postTitle.text = "lkfmsldfmlsdf"
        return cell
        
    }
    

    
}
