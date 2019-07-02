//
//  FirstViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/9/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import UIKit
import CoreData

protocol SelectedVideoDelegate {
    func didSelectVideo(_ video : String)
}

class HomeViewController: UIViewController, SelectedVideoDelegate {

    let headers = ["Featured", "Latest", "Trending", "Most Viewed"]
    var trending : [NSManagedObject] = []
    var latest : [NSManagedObject] = []
    var mostViewed : [NSManagedObject] = []
    var featured : [NSManagedObject] = []
    private let refreshControl = UIRefreshControl()

    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.bg
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.7
        self.navigationController?.navigationBar.layer.masksToBounds = false
        NotificationCenter.default.addObserver(self, selector:#selector(runRequest), name: UIApplication.willEnterForegroundNotification, object: nil)
        getData()
        runRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController
        {
            if let topItem = navController.navigationBar.topItem
            {
                topItem.title = "Absolute Scenes"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func runRequest()
    {
        AbsServer.shared.homeVideos(completion: ({ (error : Error?) in
            if error == nil
            {
                self.getData()
            }
        }))
    }
    
    func getData()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let featuredFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Featured")
        let trendingFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Trending")
        let latestFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Latest")
        let mostviewedFetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MostViewed")
        
        do {
            featured = try managedContext.fetch(featuredFetchRequest)
        } catch let error as NSError {
            print("Could not fetch featured. \(error), \(error.userInfo)")
        }
        
        do {
            trending = try managedContext.fetch(trendingFetchRequest)
        } catch let error as NSError {
            print("Could not fetch trending. \(error), \(error.userInfo)")
        }
        
        do {
            latest = try managedContext.fetch(latestFetchRequest)
        } catch let error as NSError {
            print("Could not fetch latest. \(error), \(error.userInfo)")
        }
        
        do {
            mostViewed = try managedContext.fetch(mostviewedFetchRequest)
        } catch let error as NSError {
            print("Could not fetch most viewed. \(error), \(error.userInfo)")
        }
        
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            //self.tableView.beginUpdates()
            //self.tableView.endUpdates()
        }
    }
    
    /*
    func reloadChildRows()
    {
        if let trendingCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? CollectionCell
        {
            trendingCell.collectionView.reloadData()
        }
        
        if let latestCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? CollectionCell
        {
            
        }
        
        if let mostViewedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? CollectionCell
        {
            
        }
    } */
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .bg
        tableView.backgroundColor = .bg
        tableView.backgroundView = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //tableView.contentInset.bottom = 20
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(runRequest), for: .valueChanged)

        registerCells()
    }
    
    func registerCells()
    {
      //  tableView.register(FauxNavigationCell.self, forCellReuseIdentifier: FauxNavigationCell.className)
        tableView.register(SectionHeaderCell.self, forCellReuseIdentifier: SectionHeaderCell.className)
        tableView.register(FeaturedCell.self, forCellReuseIdentifier: FeaturedCell.className)
        tableView.register(CollectionCell.self, forCellReuseIdentifier: CollectionCell.className)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let playerViewController = segue.destination as? PlayerViewController
        {
            if let video = sender as? String
            {
                playerViewController.video = video
            }
        }
        else if let allViewController = segue.destination as? AllViewController
        {
            if let identifier = sender as? CategoryIdentifier
            {
                allViewController.type = identifier
            }
        }
    }
    
    func didSelectVideo(_ video : String) {
        performSegue(withIdentifier: "playerSegue", sender: video)
    }
    
    @objc func showAll(_ button : UIButton)
    {
        var identifier = CategoryIdentifier.MostViewed
        
        if button.tag == CategoryIdentifier.Trending.rawValue
        {
            identifier = CategoryIdentifier.Trending
        }
        else if button.tag == CategoryIdentifier.Latest.rawValue
        {
            identifier = CategoryIdentifier.Latest
        }
        
        performSegue(withIdentifier: "showAllSegue", sender: identifier)
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        
        if featured.count > 0
        {
            let video = featured[0]
            let id = video.value(forKeyPath: "id") as! Int
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! FeaturedCell
            if Fav.isFavorited(id: id)
            {
                cell.likeImg.image = UIImage(named: "like_img")
                Fav.deleteFavorite(id)
            }
            else
            {
                cell.likeImg.image = UIImage(named: "like_active")
                Fav.save(video)
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let section = indexPath.section
        if section == CategoryIdentifier.Featured.rawValue
        {
            return UIScreen.main.bounds.height * 0.35
        }

        var size = UIScreen.main.bounds.width * 0.55
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            size = UIScreen.main.bounds.width * 0.4
        }
        
        return size
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == CategoryIdentifier.Featured.rawValue
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeaturedCell.className, for: indexPath) as! FeaturedCell
            if featured.count > 0
            {
                let video = featured[0]
                cell.video = video
                let id = video.value(forKeyPath: "id") as! Int
                cell.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
                if Fav.isFavorited(id: id)
                {
                    cell.likeImg.image = UIImage(named: "like_active")
                }
                else
                {
                    cell.likeImg.image = UIImage(named: "like_img")
                }
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.className, for: indexPath) as! CollectionCell
            
            //trending
            if section == CategoryIdentifier.Trending.rawValue
            {
                cell.videos = trending
                cell.delegate = self
            }
            //latest
            else if section == CategoryIdentifier.Latest.rawValue
            {
                cell.videos = latest
                cell.delegate = self
            }
            //most viewed
            else
            {
                cell.videos = mostViewed
                cell.delegate = self
            }
            
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableCell(withIdentifier: SectionHeaderCell.className) as? SectionHeaderCell else {
            return nil
        }
        
        header.headerLabel.text = headers[section]
        header.autoresizingMask = []
        header.viewButton.tag = section
        header.viewButton.addTarget(self, action: #selector(showAll(_:)), for: .touchUpInside)
        
        if section > 0
        {
            header.viewallLabel.isHidden = false
            header.viewButton.isUserInteractionEnabled = true
        }
        else
        {
            header.viewallLabel.isHidden = true
            header.viewButton.isUserInteractionEnabled = false
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50                     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            let video = featured[indexPath.row]
            if let videoID = video.value(forKeyPath: "videoId") as? String
            {
                performSegue(withIdentifier: "playerSegue", sender: videoID)
            }
        }
    }
}

