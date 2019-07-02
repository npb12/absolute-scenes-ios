//
//  AbsServer.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/24/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AbsServer : NSObject
{
    public static let shared = AbsServer()
    private let baseURL = "https://absolute-scenes.herokuapp.com/api/"
    
    public enum Endpoint: String
    {
        case videos = "videos/"
        case latest = "latest/"
        case mostViewed = "most-viewed/"
        case trending = "trending/"
        case search = "search/"
    }
    
    private func formattedEndpoint(_ endpoint: Endpoint) -> String
    {
        return baseURL + endpoint.rawValue
    }
    
    public func homeVideos(completion: @escaping (_ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.videos)
        
        if let url = URL.init(string: urlStr)
        {
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let videos = Home.toCoreData(json)
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    public func allVideos(_ endpoint : Endpoint, completion: @escaping (_ videos : [Video]?, _ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(endpoint)
        
        if let url = URL.init(string: urlStr)
        {
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let videos = Video.fromJson(json)
                    completion(videos, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func searchVideos(_ search : String, completion: @escaping (_ videos : [Video]?, _ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.search)
        let paramStr = String(format: "%@?text=%@", urlStr, search)
        
        if let url = URL.init(string: paramStr)
        {
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let videos = Video.fromJson(json)
                    completion(videos, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
