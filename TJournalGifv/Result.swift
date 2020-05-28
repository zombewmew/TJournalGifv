//
//  Result.swift
//  TJournalGifv
//
//  Created by christina on 16.05.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

enum Result<T, U: Error> {
  case success(T)
  case failure(U)
}

extension HTTPURLResponse {
  var hasSuccessStatusCode: Bool {
    return 200...299 ~= statusCode
  }
}

enum DataResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data "
    case .decoding:
      return "An error occurred while decoding data"
    }
  }
}
