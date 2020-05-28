//
//  StackExchangeClient.swift
//  TJournalGifv
//
//  Created by christina on 16.05.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

final class StackExchangeClient {
  private lazy var baseURL: URL = {
    return URL(string: "https://api.tjournal.ru/v1.8")!
  }()
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func fetch(with request: PostRequest, page: Int, completion: @escaping (Result<PostsData, DataResponseError>) -> Void) {
    // 1

    let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
    // 2

    let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
    // 3

    let encodedURLRequest = urlRequest.encode(with: parameters)
    
    session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
      // 4
      guard
        let httpResponse = response as? HTTPURLResponse,
        httpResponse.hasSuccessStatusCode,
        let data = data
      else {
          completion(Result.failure(DataResponseError.network))
          return
      }
      
      // 5

        /*if let dataString = String(data: data, encoding: .utf8) {
            //print(dataString)
            print( try? JSONDecoder().decode(PostsData.self, from: data))
        }
        //print(JSONDecoder().decode(Message.self, from: data))
        if let g = try? JSONDecoder().decode(Message.self, from: data) {
            print(g)
        }*/
        
        //if let data = data {
        
        do {
            let responseData = try JSONDecoder().decode(PostsData.self, from: data)
            } catch var error {
                 print(error)
            }
        //}
        
        /*guard let decodedResponse = try? JSONDecoder().decode(PostsData.self, from: data) else {
            completion(Result.failure(DataResponseError.decoding))
            return
        }*/
        /*if let decodedResponse = try? JSONDecoder().decode(Message.self, from: data) {
            if decodedResponse.message == "" {
                let decodedResponse = try JSONDecoder().decode(PostsData.self, from: data)
                //let userProfile = UserModel(id: responseData.result.id, name: responseData.result.name, avatar_url: responseData.result.avatar_url)
                //self.delegateAuth?.didGetUserData(self, userData: userProfile)
                print(decodedResponse)
                //return
            } else {
                //let responseData = try JSONDecoder().decode(ErrorData.self, from: data)
                //self.delegateAuth?.didFailWithError(message: responseData.message)
                completion(Result.failure(DataResponseError.decoding))
                //return
            }
        }*/
            /*if decodedResponse.message == "" {
                let decodedResponse = try JSONDecoder().decode(PostsData.self, from: data)
                //let userProfile = UserModel(id: responseData.result.id, name: responseData.result.name, avatar_url: responseData.result.avatar_url)
                //self.delegateAuth?.didGetUserData(self, userData: userProfile)
                print(decodedResponse)
                return
            } else {
                //let responseData = try JSONDecoder().decode(ErrorData.self, from: data)
                //self.delegateAuth?.didFailWithError(message: responseData.message)
                completion(Result.failure(DataResponseError.decoding))
                return
            }*/
            
        guard let decodedResponse = try? JSONDecoder().decode(PostsData.self, from: data) else {
            completion(Result.failure(DataResponseError.decoding))
            return
        }
      // 6
      completion(Result.success(decodedResponse))
    }).resume()
  }
}
