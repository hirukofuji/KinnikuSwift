//
//  SponsorListViewController.swift
//  kinniku-swift
//
//  Created by 藤川慶 on 2017/11/13.
//  Copyright © 2017年 Barberry Inc. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import SafariServices

class SponsorListViewController: UIViewController {
    let presenter = SponsorListPresenter()
    
    @IBOutlet weak var tableView: UITableView!
    
    var sponsors: [Sponsor] = []
    var personalSponsors: [PersonalSponsor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIView()
        tableView.backgroundColor = .clear
        
        let nib = UINib(nibName: String(describing: SponsorCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: SponsorCell.self))
        let nib2 = UINib(nibName: String(describing: PersonalSponsorCell.self), bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: String(describing: PersonalSponsorCell.self))
        let header = UINib(nibName: String(describing: SponsorHeader.self), bundle: nil)
        tableView.register(header, forCellReuseIdentifier: String(describing: SponsorHeader.self))
        
        getSponsor()
    }
    
    func getSponsor(){
        presenter.getSponsor({ error, sponsors in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.sponsors = sponsors
            self.getPersonalSponsor()
        })
    }
    
    func getPersonalSponsor(){
        presenter.getPersonalSponsor({ error, sponsors in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.personalSponsors = sponsors
            self.tableView.reloadData()
        })
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
}

// MARK: - <#UITableViewDataSource#>
extension SponsorListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sponsors.count
        default:
            return personalSponsors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SponsorCell.self), for: indexPath) as! SponsorCell
            cell.sponsor = sponsors[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalSponsorCell.self), for: indexPath) as! PersonalSponsorCell
            cell.sponsor = personalSponsors[indexPath.row]
            return cell
        }
    }
}

extension SponsorListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard personalSponsors.count > 0 else {
            return .leastNonzeroMagnitude
        }
        switch section {
        case 0:
            return .leastNonzeroMagnitude
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard personalSponsors.count > 0 else {
            return nil
        }
        switch section {
        case 0:
            return nil
        default:
            let header = tableView.dequeueReusableCell(withIdentifier: String(describing: SponsorHeader.self))
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let urlString = sponsors[indexPath.row].url
            if let url = URL(string: urlString) {
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

