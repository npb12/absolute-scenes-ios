//
//  FavoritesViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/16/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController : UIViewController
{
    var videos : [NSManagedObject] = []

    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.bg
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController
        {
            if let topItem = navController.navigationBar.topItem
            {
                topItem.title = "Favorites"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .bg
        tableView.backgroundColor = UIColor.bg
        tableView.backgroundView = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.contentInset.bottom = 50
        tableView.register(FavCell.self, forCellReuseIdentifier: FavCell.className)
    }
    
    func getData()
    {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        
        //3
        do {
            videos = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch featured. \(error), \(error.userInfo)")
        }
        
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
            //self.refreshControl.endRefreshing()
            //self.tableView.beginUpdates()
            //self.tableView.endUpdates()
        }
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let video = videos[indexPath.row]
        let id = video.value(forKeyPath: "id") as! Int
        let cell = tableView.cellForRow(at: indexPath) as! FavCell
        cell.likeImg.image = UIImage(named: "like_img")
        Fav.deleteFavorite(id)
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let playerViewController = segue.destination as? PlayerViewController
        {
            if let video = sender as? String
            {
                playerViewController.video = video
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UIScreen.main.bounds.height * 0.4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavCell.className, for: indexPath) as! FavCell
        cell.favorite = videos[indexPath.row]
        cell.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        cell.likeImg.image = UIImage(named: "like_active")
        cell.likeButton.tag = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            let video = videos[indexPath.row]
            if let videoID = video.value(forKeyPath: "videoId") as? String
            {
                performSegue(withIdentifier: "playerSegue", sender: videoID)
            }
            
        }
    }
}
