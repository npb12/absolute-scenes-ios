//
//  InfoViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/23/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController : UIViewController
{
    var info = InfoText()
    
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navController = self.navigationController
        {
            if let topItem = navController.navigationBar.topItem
            {
                topItem.title = info.heading
            }
        }
        
        label.text = info.text
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .bg
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    }
}
