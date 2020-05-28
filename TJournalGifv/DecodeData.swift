//
//  DecodeData.swift
//  TJournalGifv
//
//  Created by christina on 30.04.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

struct PostsData: Decodable {
    let message: String?
    let result: [DataResult]
}

struct DataResult: Decodable {
    let subsite: Subsite
    let title: String
    //let blocks: [Block]
    let cover: Cover
}

struct Cover: Decodable {
    let additionalData: additionalData
    let url: String
    let size: Size
}

struct additionalData: Decodable {
    let type: VideoType
}

enum VideoType: String, Decodable {
    case jpg = "jpg"
    case gif = "gif"
}

struct Size: Decodable {
    let width: Int
    let height: Int
}

struct Subsite: Decodable {
    let name: String
    let description: String
    let avatar_url: String
}

// MARK: - Block
struct Block: Codable {
    let type: String
    let data: BlockData
    let cover: Bool
    let anchor: String
}

// MARK: - BlockData
struct BlockData: Codable {
    let text, textTruncated: String?
    let video: Video?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case text
        case textTruncated = "text_truncated"
        case video, title
    }
}

// MARK: - Video
struct Video: Codable {
    let type: String
    let data: VideoData
}

// MARK: - VideoData
struct VideoData: Codable {
    let width, height, time: Int
    let externalService: ExternalService

    enum CodingKeys: String, CodingKey {
        case width, height, time
        case externalService = "external_service"
    }
}

// MARK: - ExternalService
struct ExternalService: Codable {
    let name, id: String
}

struct Message: Decodable {
    let message: String
}

struct ErrorData: Decodable {
    let error: ErrorArray
    let message: String
}

struct ErrorArray: Decodable {
    let code: Int
}

/*struct Post: Decodable {
    let id: Int
    let title: String
    let date: Int
    let dateRFC: String
    let intro: String
    let blocks: [Block]
}*/
/*
struct Block: Decodable {
    let type: DataType
    let data: BlockData
}

enum DataType: String, Decodable {
    case text
    case media
    case video
}

enum BlockData: Decodable {
    case text(Text)
    case video(Video)
}

struct Text: Decodable {
    
}

struct Video: Decodable {
    //let type: String
    let video: VData
}

struct VData: Decodable {
    let data: VideoData
}

struct VideoData: Decodable {
    let external_service: exService
}

struct exService: Decodable {
    let name: String
    let id: String
}*/

struct qrData: Decodable {
    let message: String
    let result: qrDataResult
}

struct qrDataResult: Decodable {
    let id: Int
    let name: String
    let avatar_url: String
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


struct ContentItem: Decodable {
    let intro: String
    let cover: Cover
}

