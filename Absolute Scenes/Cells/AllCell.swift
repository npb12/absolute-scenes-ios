//
//  AllCell.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/12/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit

class AllCell : UITableViewCell
{
    var video : Video? {
        didSet {
            if let photo = video?.coverPhoto {
                if !photo.isEmpty
                {
                    bgImage.imageFromURL(urlString: photo)
                }
            }
            if let title = video?.title{
                headerLabel.text = title
            }
            if let duration = video?.duration {
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
        view.backgroundColor = UIColor.blackish
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bgImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .LLDiv
        imageView.image = UIImage.init(named: "stubImage")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightText
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradient : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: "play_icon")
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
            timeLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView()
    {
        addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant : 10).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        
        addSubview(bgImage)
        bgImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bgImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bgImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bgImage.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -10).isActive = true
        
        bgImage.addSubview(gradient)
        gradient.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: 0).isActive = true
        gradient.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: 0).isActive = true
        gradient.topAnchor.constraint(equalTo: bgImage.topAnchor, constant: 0).isActive = true
        gradient.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: 0).isActive = true
        
        bgImage.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant : 10).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: -10).isActive = true
        
        addSubview(likeButton)
        likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        likeButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        likeButton.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
    }
}
