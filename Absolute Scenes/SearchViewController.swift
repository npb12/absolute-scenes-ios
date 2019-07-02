//
//  SearchViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/16/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UISearchController {

    var videos = [Video]()
    var searchController = UISearchController(searchResultsController: nil)
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.bg
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
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
        tableView.register(AllCell.self, forCellReuseIdentifier: AllCell.className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        //self.tableView.keyboardDismissMode = .onDrag
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchController.searchBar.barStyle = .black
        // Include the search bar within the navigation bar.
        self.definesPresentationContext = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController
        {
            if let topItem = navController.navigationBar.topItem
            {
                topItem.titleView = searchController.searchBar
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navController = self.navigationController
        {
            if let topItem = navController.navigationBar.topItem
            {
                topItem.titleView = nil
            }
        }
    }
    
    func search(_ text : String)
    {
        let formatted = text.replacingOccurrences(of: " ", with: "_")
        AbsServer.shared.searchVideos(formatted, completion: {
            (videos : [Video]?, error : Error?) in
            if error == nil
            {
                if let data = videos
                {
                    self.videos = data
                }
                
                self.tableView.reloadData()
            }
        })
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
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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


extension SearchViewController : UISearchBarDelegate, UISearchResultsUpdating
{
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text
        {
            search(text)
        }
        searchBar.resignFirstResponder()
    }
}

extension UIViewController {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
        super.touchesEnded(touches, with: event)
    }
    
}
