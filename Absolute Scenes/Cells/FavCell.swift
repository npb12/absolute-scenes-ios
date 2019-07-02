//
//  FavCell.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/17/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavCell : AllCell
{
    var favorite : NSManagedObject? {
        didSet {
            if let photo = favorite?.value(forKeyPath: "coverPhoto") as? String {
                if !photo.isEmpty
                {
                    bgImage.imageFromURL(urlString: photo)
                }
            }
            if let title = favorite?.value(forKeyPath: "title") as? String {
                headerLabel.text = title
            }
            if let duration = favorite?.value(forKeyPath: "duration") as? String {
                let durationStr = Video.getDuration(duration)
                timeLabel.text = durationStr
            }
        }
    }
}
