//
//  DataModel.swift
//  TJournalGifv
//
//  Created by christina on 30.04.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

struct PostModel {
    let name: String
    let type: VideoType
    let video_url: URL
}

struct SubsiteModel {
    let name: String
    let description: String
    let avatar_url: String
}

struct UserModel {
    let id: Int
    let name: String
    let avatar_url: String
}
