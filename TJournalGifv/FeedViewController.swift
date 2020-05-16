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
    
    var postManager = RequestManager()
    var posts: [PostModel] = []
    
    //1
    //let video = videos[indexPath.row]

    //2
    //let videoURL = video.url
    //let videoURL = URL(string: "https://www.youtube.com/watch?v=zsc-S3-b1YU")
    let player = AVPlayer(url: URL(string: "https://www.youtube.com/watch?v=zsc-S3-b1YU")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.register(UINib(nibName: "FeedViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.prefetchDataSource = self
        
        //feedTableView.rowHeight = UITableView.automaticDimension
        //feedTableView.estimatedRowHeight = 500.0
        
        postManager.delegateFeed = self
        postManager.fetchPosts()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= posts.count
    }

}

//MARK: - Table View Controller Extension

extension FeedViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedViewCell
        
        /*if posts[indexPath.row].name != "" {
            cell.postTitle.text = posts[indexPath.row].name
        } else {
            cell.postTitle.text = "Без заголовка"
            //cell.postTitle.frame.size.height = 0
            //cell.postTitle.frame.size.width = 0
            //cell.postTitle.isHidden = true
        }
        */
        cell.configure(post: posts[indexPath.row])
        
        if isLoadingCell(for: indexPath) {
            print(indexPath)
            //cell.configure(with: nil)
        } else {
            cell.configure(post: posts[indexPath.row])
            //cell.configure(with: posts.contentItem(at: indexPath.row))
        }
        
        
        //let videoURL = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        //let videoURL = URL(string: "https://www.youtube.com/watch?v=zsc-S3-b1YU")
        //let player = AVPlayer(url: videoURL!)
        /*cell.postView.frame.size.height = CGFloat(posts[indexPath.row].height)
        print(cell.postView.frame.size.height)
        let player = AVPlayer(url: posts[indexPath.row].video_url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cell.bounds
        
        cell.layer.addSublayer(playerLayer)
        cell.postView.layer.addSublayer(playerLayer)*/
        
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
        

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedViewCell else { return }
        cell.play()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedViewCell else { return }
        cell.pause()
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            postManager.fetchPosts()
        }
    }
    
}

// MARK: - Extension for Request Delegate

extension FeedViewController: RequestFeedManagerDelegate {
    func didUpdatePosts(_: RequestManager, posts: [PostModel], subsite: SubsiteModel) {
        DispatchQueue.main.async {
            self.subsiteTitle.text = subsite.name
            self.subsiteDescription.text = subsite.description
            self.subsiteImage.load(url: (URL(string: subsite.avatar_url)!))
            
            self.posts = posts
            self.feedTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
