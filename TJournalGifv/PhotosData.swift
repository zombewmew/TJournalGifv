//
//  PhotosData.swift
//  TJournalGifv
//
//  Created by christina on 30.04.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

struct PhotosData: Decodable {
    let result: Subsite
    let message: String
    //let stat: String
}

struct Subsite: Decodable {
    let name: String
    let description: String
    let avatar_url: String
}

struct Post: Decodable {
    let id: Int
    let title: String
    let date: Int
    let dateRFC: String
    let intro: String
    /*let cover: Cover?*/
    let blocks: [Blocks]
    /*var postImage: Data?*/
}

struct Blocks: Decodable {
    let type: String
    let data: Video
}

struct Video: Decodable {
    let type: String
    let data: VideoData
}

struct VideoData: Decodable {
    let external_service: exService
}

struct exService: Decodable {
    let name: String
    let id: String
}

/*struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    var photoUrl: URL? {
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
        return URL(string: urlString)
    }
    
    var thumbnailUrl: URL? {
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        return URL(string: urlString)
    }
}*/
