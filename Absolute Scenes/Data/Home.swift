//
//  Home.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/24/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

public class Home
{
    public struct JsonKeys
    {
        static let trending = "trending"
        static let latest = "latest"
        static let mostViewed = "mostViewed"
        static let featured = "featured"
    }
    
    var featured = Video()
    var trending = [Video]()
    var latest = [Video]()
    var mostViewed = [Video]()
    
    public static func toCoreData(_ json: JSON) -> Home
    {
        let home = Home()
        home.featured = Video.parseVideo(json["featured"])
        Home.save([home.featured], "Featured")
        home.trending = Video.fromJson(json["trending"])
        Home.save(home.trending, "Trending")
        home.latest = Video.fromJson(json["latest"])
        Home.save(home.latest, "Latest")
        home.mostViewed = Video.fromJson(json["mostViewed"])
        Home.save(home.mostViewed, "MostViewed")
        return home
    }
    
    static func save(_ videos: [Video], _ entityStr : String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: entityStr,
                                       in: managedContext)!
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityStr)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedContext.execute(request)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
        
        for video in videos
        {
            let object = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            // 3
            object.setValue(video.id, forKeyPath: "id")
            object.setValue(video.title, forKeyPath: "title")
            object.setValue(video.coverPhoto, forKeyPath: "coverPhoto")
            object.setValue(video.videoId, forKeyPath: "videoId")
            object.setValue(video.duration, forKeyPath: "duration")

            // 4
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
