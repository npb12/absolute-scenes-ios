//
//  SectionHeaderCell.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 5/23/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import UIKit

class SectionHeaderCell : UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .bg
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.text = "HEADER LABEL"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.showColor
        label.numberOfLines = 1
        label.text = "Show All"
        label.isHidden = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        return button
    }()
    
    func setupView()
    {
        addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        addSubview(viewButton)
        viewButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        viewButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        viewButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        viewButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(viewallLabel)
        viewallLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        viewallLabel.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        
    }
}
