//
//  AllViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/12/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AllViewController : UIViewController
{
    var type = CategoryIdentifier.Latest
    var heading = ""
    var videos = [Video]()
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.bg
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = heading
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        var endpoint = AbsServer.Endpoint.latest
        
        if type == CategoryIdentifier.MostViewed
        {
            endpoint = AbsServer.Endpoint.mostViewed
        }
        else if type == CategoryIdentifier.Trending
        {
            endpoint = AbsServer.Endpoint.trending
        }
        
        AbsServer.shared.allVideos(endpoint, completion: ({ (videos : [Video]?, error : Error?) in
            if error == nil
            {
                if let videos = videos
                {
                    self.videos = videos
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if videos.count > 10
                        {
                            self.tableView.scrollToRow(at: IndexPath(row: 10, section: 0), at: .top, animated: false)
                        }
                    }
                }
            }
        }))
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .bg
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.contentInset.bottom = 50
        tableView.register(AllCell.self, forCellReuseIdentifier: AllCell.className)
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let video = videos[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! AllCell
        if Fav.isFavorited(id: video.id)
        {
            cell.likeImg.image = UIImage(named: "like_img")
            Fav.deleteFavorite(video.id)
        }
        else
        {
            cell.likeImg.image = UIImage(named: "like_active")
            Fav.save(video)
        }
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
extension AllViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AllCell.className, for: indexPath) as! AllCell
        let video = videos[indexPath.row]
        cell.video = video
        cell.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        cell.likeButton.tag = indexPath.row
        if Fav.isFavorited(id: video.id)
        {
            cell.likeImg.image = UIImage(named: "like_active")
        }
        else
        {
            cell.likeImg.image = UIImage(named: "like_img")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            let video = videos[indexPath.row]
            performSegue(withIdentifier: "playerSegue", sender: video.videoId)

        }
    }
}
