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
    
    private var viewModel: FeedViewModel!
    var postManager = RequestManager()
    var posts: [PostModel] = []
    var site: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.register(UINib(nibName: "FeedViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        //feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.prefetchDataSource = self
        feedTableView.isHidden = true

        
        //postManager.delegateFeed = self
        
        let request = PostRequest.getRequest()
        viewModel = FeedViewModel(request: request, delegate: self)
        viewModel.fetch()
        //postManager.fetchPosts()

    }

}

//MARK: - Table View Controller Extension

extension FeedViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(viewModel!)
        //return viewModel.totalCount
        return 100
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
        //print("cell")
        //print(posts[indexPath.row])
        //cell.configure(post: posts[indexPath.row])
        
        
        /*if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        
        } else {
            print("mew")
            //cell.configure(with: viewModel.contentItem(at: indexPath.row))
            cell.configure(post: viewModel.posts(at:indexPath.row))
        }*/
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
            //print("nil")
        } else {
            cell.configure(with: viewModel.contentItem(at: indexPath.row))
            //print("sfsdf")
        }
        
        
        /*if isLoadingCell(for: indexPath) {
            print(indexPath)
            //cell.configure(with: nil)
        } else {
            cell.configure(post: posts[indexPath.row])
            //cell.configure(with: posts.contentItem(at: indexPath.row))
        }*/
        
        
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
            viewModel.fetch()
        }
    }
    
    
}

// MARK: - Extension for Request Delegate

extension FeedViewController: FeedViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            
            feedTableView.isHidden = false
            feedTableView.reloadData()
            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        feedTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
  
    func onFetchFailed(with reason: String) {
        print(reason)
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



private extension FeedViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        //print(indexPath.row)
        //print(viewModel.currentCount)
        //print(indexPath.row >= viewModel.currentCount)
        //print("mew")
        return indexPath.row >= viewModel.currentCount
    }
  
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = feedTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
