//
//  CollectionCell.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/24/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import UIKit
import CoreData

class CollectionCell : UITableViewCell
{
    //var videos = [Video]()
    var videos : [NSManagedObject] = []
    var delegate : SelectedVideoDelegate?
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.translatesAutoresizingMaskIntoConstraints = false
        collectView.backgroundColor = UIColor.bg
        collectView.showsHorizontalScrollIndicator = false
        collectView.bounces = true
        return collectView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.className)
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        let offset : CGFloat = 15
        collectionView.contentInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let video = videos[indexPath.row]
        let id = video.value(forKeyPath: "id") as! Int
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
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

extension CollectionCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.className, for: indexPath) as! ItemCell
        let video = self.videos[indexPath.row]
        let id = video.value(forKeyPath: "id") as! Int
        cell.video = video
        cell.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        cell.likeButton.tag = indexPath.row
        if Fav.isFavorited(id: id)
        {
            cell.likeImg.image = UIImage(named: "like_active")
        }
        else
        {
            cell.likeImg.image = UIImage(named: "like_img")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = UIScreen.main.bounds.width * 0.6
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            width = UIScreen.main.bounds.width * 0.3
        }
        
        let height = self.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let video = videos[indexPath.row]
        if let videoID = video.value(forKeyPath: "videoId") as? String
        {
            delegate?.didSelectVideo(videoID)
        }
    }
}
