//
//  RequestManager.swift
//  TJournalGifv
//
//  Created by christina on 30.04.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import Foundation

protocol RequestManagerDelegate {
    func didUpdatePhotos(_: RequestManager, photos: [PhotoModel])
    func didFailWithError(error: Error)
}

struct RequestManager {
    //let apiToken = "14bc838679092909de6dc493a3a218b98371982b66981da3058b22e240ea431b"
    //78c52895d29547e179b5e36527c709fbbaacc13a3cd6dff866da16536700ab80
    //let tjUrl = URL(string: "https://api.tjournal.ru/v1.8/subsite/237832/timeline/new?count=10")!
    
    let tjUrl = URL(string: "https://api.tjournal.ru/v1.8/subsite/237832/")!
    
    let meUrl = URL(string: "https://api.tjournal.ru/v1.8/user/me")!
    
    let qrUrl = URL(string: "https://api.tjournal.ru/v1.8/auth/qr")!
    
    //let request = NSMutableURLRequest(url: NSURL(string: http://endpoint)! as URL)
    
    /*var request = URLRequest(url: tjUrl)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")*/
    
    //request.addValue("4180b1645f624408b6291349204122344", forHTTPHeaderField: "X-Auth-Token")
    //request.HTTPMethod = "GET" // or POST or whatever
    //NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
        // handle your data here
    //}
    
    //let requestURL = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=a7728079742776c4bbf0bc9f47661701&format=json&nojsoncallback=1&per_page=20"
    
    var delegate: RequestManagerDelegate?
    
    func fetchPhotos() {
        
        var request = URLRequest(url: tjUrl)
        request.httpMethod = "GET"
        //request.
        //request.addValue(apiToken, forHTTPHeaderField: "X-Device-Token")
        //request.add
        
        //let urlString = "\(requestURL)"
        performRequest(with: request)
    }
    
    func auth(token: String) {
        
        print(token)
        var request = URLRequest(url: qrUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "token=\(token)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
        
        /*var request = URLRequest(url: qrUrl)
        
        
        request.httpMethod = "POST"
        //apiToken = token
        //request.addValue(token, forHTTPHeaderField: "X-Device-Token")
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("multipart/form-data; token=\(token)", forHTTPHeaderField: "Content-Type")
        
        
        //create the session object
        let session = URLSession.shared

        do {
            //let bodyData = "token=\(token)"
            //print(bodyData.data(using: .utf8))
            //request.httpBody = bodyData.data(using: .utf8)
            
            let d = "token=\(token)"
            print(d)
            request.httpBody = d.data(using: .utf8)
            //request.httpBody = bodyData.data(using: .utf8)
            //request.httpBody = bodyData.data(using: <#String.Encoding#>, usingEncoding: NSUTF8StringEncoding);
            //request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        */

    
        //create dataTask using the session object to send data to the server
        /*let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                print(request.httpBody)
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()*/
    
    }
    
    func performRequest(with request: URLRequest) {
                
        //if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let photos = self.parseJson(safeData) {
                        self.delegate?.didUpdatePhotos(self, photos: photos as! [PhotoModel])
                    }
                    //print(safeData)
                }
                
            }
            task.resume()
        //}
    }
    
    func parseJson(_ photosData: Data) -> [PhotoModel?]? {
        print(photosData)
        var photosResult: [PhotoModel?] = []
        let decoder = JSONDecoder()
        do {
            print("dsfsd")
            print(try decoder.decode(PhotosData.self, from: photosData))
            let decodeData = try decoder.decode(PhotosData.self, from: photosData)
            print(decodeData.message.count)
            /*for item in decodeData.photos.photo {
                
                let photo = PhotoModel(id: item.id, posterUrl: item.photoUrl, thumbnailUrl: item.thumbnailUrl)
                photosResult.append(photo)
                
            }*/
            
            return photosResult

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }

    }
    
}

