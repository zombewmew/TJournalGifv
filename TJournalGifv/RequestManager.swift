//
//  RequestManager.swift
//  TJournalGifv
//
//  Created by christina on 30.04.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

protocol RequestFeedManagerDelegate {
    func didUpdatePosts(_: RequestManager, posts: [PostModel], subsite: SubsiteModel)
    func didFailWithError(error: Error)
}

protocol RequestAuthManagerDelegate {
    func didGetUserData(_: RequestManager, userData: UserModel)
    func didFailWithError(message: String)
}


struct RequestManager {
    
    let apiDeveloperToken = "14bc838679092909de6dc493a3a218b98371982b66981da3058b22e240ea431b"
    
    let postsUrl = URL(string: "https://api.tjournal.ru/v1.8/subsite/237832/timeline/new?count=10")!
    let subsiteUrl = URL(string: "https://api.tjournal.ru/v1.8/subsite/237832/")!
    let meUrl = URL(string: "https://api.tjournal.ru/v1.8/user/me")!
    let qrUrl = URL(string: "https://api.tjournal.ru/v1.8/auth/qr")!
    
    var delegateFeed: RequestFeedManagerDelegate?
    var delegateAuth: RequestAuthManagerDelegate?
    
    
    //MARK: - Аuthorization
    
    func auth(token: String) {
        
        var request = URLRequest(url: qrUrl)
        let postString = "token=\(token)";
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8);

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let longToken = response.value(forHTTPHeaderField: "x-device-token") {
                        let data = Data(from: longToken)
                        
                        let status = KeyChain.save(key: "token", data: data)
                        print("status: ", status)

                    }
                }
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
                print("Response data string:\n \(dataString)")
                do {
                    let responseData = try JSONDecoder().decode(Message.self, from: data)
                    if responseData.message == "" {
                        let responseData = try JSONDecoder().decode(qrData.self, from: data)
                        let userProfile = UserModel(id: responseData.result.id, name: responseData.result.name, avatar_url: responseData.result.avatar_url)
                        self.delegateAuth?.didGetUserData(self, userData: userProfile)
                        
                    } else {
                        let responseData = try JSONDecoder().decode(ErrorData.self, from: data)
                        self.delegateAuth?.didFailWithError(message: responseData.message)
                    }
                    
                } catch let error {
                     print(error)
                }
            }
        }
        task.resume()
    
    }
    
    //MARK: - Subcite Description Request
    func fetchDescription() {
        var request = URLRequest(url: subsiteUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            /*if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(PostsData.self, from: data)
                    let post = PostModel(name: responseData.result.name, description: responseData.result.description, avatar_url: responseData.result.avatar_url)
                    posts.append(photo)
                    self.delegateFeed?.didUpdatePosts(self, posts: posts)
                    
                    
                } catch let error {
                     print(error)
                }
            }*/
            
            /*if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(PostsData.self, from: data)
                    let post = PostModel(name: responseData.result.name, description: responseData.result.description, avatar_url: responseData.result.avatar_url)
                    posts.append(photo)
                    self.delegateFeed?.didUpdatePosts(self, posts: posts)
                    
                    
                } catch let error {
                     print(error)
                }
            }*/
        }
        task.resume()
    }
    
    //MARK: - Video Posts Request
    
    func fetchPosts() {
        
        var posts: [PostModel?] = []
        var post: PostModel?
        var request = URLRequest(url: postsUrl)
        var url: URL?
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data {
                
                do {
                    let responseData = try JSONDecoder().decode(PostsData.self, from: data)
                    for item in responseData.result {
                        /*for block in item.blocks {
                            
                            if block.type == "video" {
                                
                                //try JSONDecoder().decode(Video.self, from: block as Data)
                            
                                if let external = block.data.video?.data.externalService.name,
                                    let id = block.data.video?.data.externalService.id {
                                    if external == "youtube" {
                                        url = URL(string: "https://www.youtube.com/embed/\(id)")
                                    }
                                }
                            }
                            //print(block.data.video?.data.externalService.name)
                            //block.data.video?.data.externalService.name
                            //let externalService = block.data.video.data.external_service.name
                            //print(externalService)
                            
                             
                            post = PostModel(name: item.title, type: block.type, video_url: url ?? URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
                        }*/
                        
                        url = URL(string: item.cover.url)
                        
                        post = PostModel(name: item.title, type: item.cover.additionalData.type, video_url: url ?? URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
                        
                        posts.append(post)
                    }
                    
                    let subsite = SubsiteModel(name: responseData.result[0].subsite.name, description: responseData.result[0].subsite.description, avatar_url: responseData.result[0].subsite.avatar_url)
                    
                    self.delegateFeed?.didUpdatePosts(self, posts: posts as! [PostModel], subsite: subsite)
                    
                    
                } catch let error {
                     print(error)
                }
            }
            
            /*if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(PostsData.self, from: data)
                    let post = PostModel(name: responseData.result.name, description: responseData.result.description, avatar_url: responseData.result.avatar_url)
                    posts.append(photo)
                    self.delegateFeed?.didUpdatePosts(self, posts: posts)
                    
                    
                } catch let error {
                     print(error)
                }
            }*/
        }
        task.resume()
        
        //performRequest(with: request)
        
    }
    

    
    /*func performRequest(with request: URLRequest) {
                
        //if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegateFeed?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data, let dataString = String(data: data!, encoding: .utf8) {
                    print(dataString)
                    if let photos = self.parseJson(safeData) {
                        self.delegateFeed?.didUpdatePosts(self, photos: photos as! [PostModel])
                    }
                }
                
            }
            task.resume()
        //}
    }
    
    func parseJson(_ postsData: Data) -> [PostModel?]? {
        
        var postResult: [PostModel?] = []
        let decoder = JSONDecoder()
        do {
            //print("dsfsd")
            //print(try decoder.decode(PhotosData.self, from: photosData))
            let decodeData = try decoder.decode(PostsData.self, from: postsData)
            print(decodeData.result.name)
            /*for item in decodeData.photos.photo {
                
                let photo = PhotoModel(id: item.id, posterUrl: item.photoUrl, thumbnailUrl: item.thumbnailUrl)
                photosResult.append(photo)
                
            }*/
            
            return postResult

        } catch {
            delegateFeed?.didFailWithError(error: error)
            return nil
        }

    }*/
    
}

