//
//  Video.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/24/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class Video
{
    public struct JsonKeys
    {
        static let id = "id"
        static let title = "title"
        static let description = "description"
        static let videoId = "videoId"
        static let coverPhoto = "coverPhoto"
        static let publishDate = "publishDate"
        static let viewCount = "viewCount"
        static let channel = "channel"
        static let duration = "duration"
    }
    
    var id : Int = 0
    var title : String = ""
    var description : String = ""
    var videoId : String = ""
    var coverPhoto : String = ""
    var duration : String = ""
    var publishDate : Date? = nil
    var viewCount : Int = 0

    public static func fromJson(_ json: JSON) -> [Video]
    {
        var videos = [Video]()
        
        for (_, object) in json
        {
            let video = Video.parseVideo(object)
            videos.append(video)
        }
        
        return videos
    }
    
    public static func parseVideo(_ object : JSON) -> Video
    {
        let video = Video()
        
        if let id = object[JsonKeys.id].int
        {
            video.id = id
        }
        
        if let title = object[JsonKeys.title].string
        {
            video.title = title
        }
        
        if let description = object[JsonKeys.description].string
        {
            video.description = description
        }
        
        if let duration = object[JsonKeys.duration].string
        {
            video.duration = duration
        }
        
        if let videoId = object[JsonKeys.videoId].string
        {
            video.videoId = videoId
        }
        
        if let coverPhoto = object[JsonKeys.coverPhoto].string
        {
            video.coverPhoto = coverPhoto
        }
        
        if let count = object[JsonKeys.viewCount].int
        {
            video.viewCount = count
        }
        
        return video
    }
    
    static func getDuration(_ str : String) -> String
    {
        var time = str
        
        for char in time {
            if char == "0" || char == ":"
            {
                if let index = time.index(time.startIndex, offsetBy: 0, limitedBy: time.endIndex) {
                    time.remove(at: index)
                }
            }
            else
            {
                break
            }
        }
        
        return time
    }
}
