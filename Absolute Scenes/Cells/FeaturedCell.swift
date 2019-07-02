//
//  FeaturedCell.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/23/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//


import UIKit
import CoreData

class FeaturedCell : UITableViewCell
{    
    var video : NSManagedObject? {
        didSet {
            if let photo = video?.value(forKeyPath: "coverPhoto") as? String {
                if !photo.isEmpty
                {
                    bgImage.imageFromURL(urlString: photo)
                }
            }
            if let title = video?.value(forKeyPath: "title") as? String {
                headerLabel.text = title
            }
            if let duration = video?.value(forKeyPath: "duration") as? String {
                let durationStr = Video.getDuration(duration)
                timeLabel.text = durationStr
            }
        }
    }
    
    override func prepareForReuse() {
        bgImage.image = nil
    }
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        //view.layer.borderColor = UIColor.gray.cgColor
        //view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bgImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .LLDiv
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let gradient : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightText
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "play_icon")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let timeLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.semibold)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textColor = UIColor.white
        label.layer.cornerRadius = 2.5
        label.text = "1:05"
        label.isUserInteractionEnabled = false
        label.isScrollEnabled = false
        label.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "like_img")
        imageView.alpha = 0.8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .bg
        setupView()
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            headerLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView()
    {
        addSubview(viewContainer)
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        
        viewContainer.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 5).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(bgImage)
        bgImage.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        bgImage.topAnchor.constraint(equalTo: viewContainer.topAnchor).isActive = true
        bgImage.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        bgImage.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -10).isActive = true
        
        bgImage.addSubview(gradient)
        gradient.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: 0).isActive = true
        gradient.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: 0).isActive = true
        gradient.topAnchor.constraint(equalTo: bgImage.topAnchor, constant: 0).isActive = true
        gradient.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: 0).isActive = true
        
        bgImage.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant : 10).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: -10).isActive = true
        
        viewContainer.addSubview(likeButton)
        likeButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        likeButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        likeButton.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
    }
}
