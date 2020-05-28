//
//  PostRequest.swift
//  TJournalGifv
//
//  Created by christina on 16.05.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation


struct PostRequest {
    var path: String {
        return "/subsite/237832/timeline/new"
    }
  
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension PostRequest {
  static func getRequest() -> PostRequest {
    let parameters: Parameters = [:]
    //let defaultParameters = ["order": "desc", "sort": "reputation", "filter": "!-*jbN0CeyJHb"]
    //let parameters = ["site": "\(site)"].merging(defaultParameters, uniquingKeysWith: +)
    return PostRequest(parameters: parameters)
  }
}


/*struct ContentRequest {
    func path(subsiteID: String, sorting: SortingType) -> String {
        "subsite/\(subsiteID)/timeline/\(sorting.rawValue)"
    }
    
    let parameters: Parameters
    
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ContentRequest {
    static func getRequest() -> ContentRequest {
        let parameters: Parameters = [:]
        return ContentRequest(parameters: parameters)
    }
}*/
