//
//  HomeNavigationCell.swift
//  Stitcher
//
//  Created by Neil Ballard on 4/25/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit

class FauxNavigationCell : UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .main
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.header
        label.numberOfLines = 1
        label.text = "Absolute Scenes"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "navLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.AScenes
        label.numberOfLines = 1
        label.text = "Search Keywords..."
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "search_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let recorderImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "recorder_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupView()
    {
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        
        addSubview(profileImg)
        profileImg.topAnchor.constraint(equalTo: topAnchor, constant: screenHeight * 0.025).isActive = true
        profileImg.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: screenWidth * 0.05).isActive = true
        profileImg.widthAnchor.constraint(equalToConstant: 25).isActive = true
        profileImg.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 10).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: profileImg.centerYAnchor).isActive = true
        
        /*
        addSubview(searchContainer)
        searchContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: screenWidth * 0.05).isActive = true
        searchContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -(screenWidth * 0.05)).isActive = true
        searchContainer.topAnchor.constraint(equalTo: profileImg.bottomAnchor, constant: screenHeight * 0.025).isActive = true
        searchContainer.heightAnchor.constraint(equalToConstant: screenHeight * 0.065).isActive = true
        
        searchContainer.addSubview(searchImg)
        searchImg.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor).isActive = true
        searchImg.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: screenWidth * 0.05).isActive = true
        searchImg.widthAnchor.constraint(equalToConstant: 20).isActive = true
        searchImg.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        searchContainer.addSubview(searchLabel)
        searchLabel.leadingAnchor.constraint(equalTo: searchImg.trailingAnchor, constant: 10).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor).isActive = true
        
        searchContainer.addSubview(recorderImg)
        recorderImg.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor).isActive = true
        recorderImg.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -(screenWidth * 0.05)).isActive = true
        recorderImg.widthAnchor.constraint(equalToConstant: 25).isActive = true
        recorderImg.heightAnchor.constraint(equalToConstant: 25).isActive = true

        setupSearchShadow() */
    }
    
    func setupSearchShadow()
    {
        let shadowView = UIView.init(frame: self.searchContainer.frame)
        shadowView.backgroundColor = .clear
        self.searchContainer.superview?.addSubview(shadowView)
        shadowView.addSubview(self.searchContainer)
        self.searchContainer.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.searchContainer.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        self.searchContainer.layoutIfNeeded()
        self.searchContainer.layer.cornerRadius = 5//self.searchContainer.bounds.height / 2
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.075
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
}
