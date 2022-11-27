//
//  NetworkManager.swift
//  CuteKittens
//
//  Created by Neely Rhaego on 11/14/22.
//

import Foundation
import UIKit

enum NetworkManagerError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}

fileprivate struct APIResponse: Codable {
    let results: [Post]
}

class NetworkManager {

    static var shared = NetworkManager()
    
    private var cacheImages = NSCache<NSString, NSData>()
    
    var pageNumber: Int
    var fetchingMore: Bool = false
    
    let session : URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        pageNumber = 1
    }
    
    private func components() -> URLComponents {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "api.unsplash.com"
        return comp
    }
    
    private func request(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        let accessKey = "your key"
        request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func posts(query: String, completion: @escaping ([Post]?, Error?) -> (Void)) { //?
        var comp = components()
        comp.path = "/search/photos"
        comp.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(pageNumber)),
        ]
        let req = request(url: URL(string: comp.url!.description + "/rel=next")!)
        
        let task = session.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponce = response as? HTTPURLResponse, (200...299).contains(httpResponce.statusCode) else { completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            
            do {
//            let str = String(decoding: data, as: UTF8.self)
//                print(str)
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(response.results, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        if let imageData = cacheImages.object(forKey: imageURL.absoluteString as NSString) { //using cached images
            completion(imageData as Data, nil)
            return()
        }
        let task = session.downloadTask(with: imageURL) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponce = response as? HTTPURLResponse, (200...299).contains(httpResponce.statusCode) else { completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                self.cacheImages.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()

    }
    
    func image(post: Post, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: post.urls.regular)!
        download(imageURL: url, completion: completion)
    }
    
    func profileImage(post: Post, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: post.user.profileImage.medium)!
        download(imageURL: url, completion: completion)
    }
    
}
