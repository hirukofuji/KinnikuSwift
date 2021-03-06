//
//  MenuViewController.swift
//  kinniku-swift
//
//  Created by 藤川慶 on 2017/11/11.
//  Copyright © 2017年 Barberry Inc. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class SideMenuViewController: MenuViewController {
    let presenter = MenuPresenter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: String(describing: AboutCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: AboutCell.self))
    }
}

// MARK: - Table view data source
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.menuStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutCell.self), for: indexPath)
            return cell
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.textLabel?.text = presenter.menuStrings[indexPath.row]
        cell.textLabel?.textColor = UIColor.theme
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuContainer = self.menuContainerViewController else { return }
        
        let target = menuContainer.contentViewControllers[indexPath.row]
        menuContainer.selectContentViewController(target)
        menuContainer.hideSideMenu()
    }
    
}
