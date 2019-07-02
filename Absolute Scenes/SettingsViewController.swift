//
//  SettingsViewController.swift
//  Absolute Scenes
//
//  Created by Neil Ballard on 6/16/19.
//  Copyright © 2019 Ditto IO. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
    let labels = ["Share with Friends", "  About", "Privacy Policy", "Contact Us", "Terms of Service", "Report a Problem", "Rate in App Store"]
    let icons = ["share_icon", "about_icon", "privacy_icon", "contact_icon", "tos_icon", "report_icon", "rate_icon"]
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
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
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.contentInset.bottom = 50
        tableView.register(FavCell.self, forCellReuseIdentifier: FavCell.className)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController
        {
            if let topItem = navController.navigationBar.topItem
            {
                topItem.title = "Settings"
            }
        }
    }
    
    func shareApp()
    {
        if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8") {
            let message : String = "The latest and greatest football highlights on Absolute Scenes: "
            let objectsToShare = [message, urlStr] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func infoSegue(_ info : InfoText)
    {
        performSegue(withIdentifier: "infoSegue", sender: info)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? InfoViewController
        {
            if let info = sender as? InfoText
            {
                viewController.info = info
            }
        }
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = labels[indexPath.section]
        cell.imageView?.image = UIImage(named: icons[indexPath.section])?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor.lightText
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var info = InfoText()
        
        switch indexPath.section {
        case 0:
            shareApp()
            return
        case 1:
            info.heading = "About"
            info.text = InfoText.about
            break
        case 2:
            info.heading = "Privacy Policy"
            info.text = InfoText.privacy
            break
        case 3:
            info.heading = "Contact Us"
            info.text = InfoText.contact
            break
        case 4:
            info.heading = "Terms of Service"
            info.text = InfoText.tos
            break
        case 5:
            info.heading = "Report a Problem"
            info.text = InfoText.report
            break
        case 6:
            SKStoreReviewController.requestReview()
            return
        default:
            return
        }
        
        infoSegue(info)
    }
}
