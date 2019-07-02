//
//  Favorite.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/16/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Fav
{
    static func save(_ video: NSManagedObject) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityStr = "Favorite"
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: entityStr,
                                       in: managedContext)!
        let object = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        let id = video.value(forKeyPath: "id") as! Int
        let title = video.value(forKeyPath: "title") as! String
        let coverPhoto = video.value(forKeyPath: "coverPhoto") as! String
        let duration = video.value(forKeyPath: "duration") as! String
        let videoId = video.value(forKeyPath: "videoId") as! String

        // 3
        object.setValue(id, forKeyPath: "id")
        object.setValue(title, forKeyPath: "title")
        object.setValue(coverPhoto, forKeyPath: "coverPhoto")
        object.setValue(videoId, forKeyPath: "videoId")
        object.setValue(duration, forKeyPath: "duration")

        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func save(_ video: Video) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityStr = "Favorite"
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: entityStr,
                                       in: managedContext)!
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
    
    
    
    static func deleteFavorite(_ id: Int)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.performAndWait
            {
                let entityName = "Favorite"

                let predicate = NSPredicate(format: "id == %d", id)
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                fetch.predicate = predicate
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try managedContext.execute(request)
                    try managedContext.save()
                } catch {
                    print ("There was an error")
                }
        }
    }
    
    static func isFavorited(id: Int) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityName = "Favorite"

        let predicate = NSPredicate(format: "id == %d", id)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    static func dataCount() -> Int {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return 0
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entityName = "Favorite"

        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount
    }
    
    static func itemExists(id: Int) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}
