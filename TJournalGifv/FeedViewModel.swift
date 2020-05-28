//
//  FeedViewModel.swift
//  TJournalGifv
//
//  Created by christina on 16.05.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

protocol FeedViewModelDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

class FeedViewModel {
    private weak var delegate: FeedViewModelDelegate?
    
    private var posts: [PostModel] = []
    //private var content = [DataResult]()
    
        private var content = [DataResult]()
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = StackExchangeClient()
    let request: PostRequest
    
    init(request: PostRequest, delegate: FeedViewModelDelegate) {
      self.request = request
      self.delegate = delegate
    }
    
    var totalCount: Int {
      return total
    }
    
    var currentCount: Int {
      return posts.count
    }
    
    func contentItem(at index: Int) -> DataResult {
        content[index]
    }
    
    /*func posts(at index: Int) -> DataResult {
      return content[index]
    }*/
    
    func fetch() {
              
      guard !isFetchInProgress else { return }
      
      isFetchInProgress = true
      
      /*client.fetchModerators(with: request, page: currentPage) { result in
        switch result {
        // 3
        case .failure(let error):
          DispatchQueue.main.async {
            self.isFetchInProgress = false
            self.delegate?.onFetchFailed(with: error.reason)
          }
        // 4
        case .success(let response):
            DispatchQueue.main.async {
                self.isFetchInProgress = false
                
                self.posts += response.result
                
                if self.currentPage > 0 {
                    let indexPathToReload = self.calculateIndexPathsToReload(from: response.result)
                    self.delegate?.onFetchCompleted(with: indexPathToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: nil)
                }
                
                self.currentPage += 1
                    
            }
          }
        }*/
        
        client.fetch(with: request, page: currentPage, completion: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    
                    self.content += response.result
                    
                    if self.currentPage > 0 {
                        let indexPathToReload = self.calculateIndexPathsToReload(from: response.result)
                        self.delegate?.onFetchCompleted(with: indexPathToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: nil)
                    }
                    
                    self.currentPage += 1
                    
                }
            }
        })
    }
    
    private func calculateIndexPathsToReload(from newPost: [DataResult]) -> [IndexPath] {
        let startIndex = posts.count - newPost.count
        let endIndex = startIndex + newPost.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
