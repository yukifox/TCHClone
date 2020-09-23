//
//  SettingVC.swift
//  TCHClone
//
//  Created by Trần Huy on 9/9/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class SettingVC: UITableViewController {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            if user == nil {
                isLogin = false
            }
        }
    }
    var isLogin: Bool = false
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        configTableView()
        requestNoti()
        
    }
    
    func configNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(handlerClose))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Cài đặt"
    }
    
    func configTableView() {
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        tableView.backgroundColor = .groupTableViewBackground
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        
        
    }
    
    //MARK: - Delegate TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLogin ? 3 : 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        if isLogin {
            let menuCell = SettingsOption(rawValue: indexPath.row)
            cell.cellType = menuCell
            if indexPath.row == 2 {
                cell.selectionStyle = .none
            }
        } else {
            let menuCell = SettingsOption(rawValue: 2)
            cell.cellType = menuCell
            cell.selectionStyle = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = SettingsOption(rawValue: isLogin ? indexPath.row : 2)
        handlerDidSelectSettingsOption(for: cell!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Handler
    func requestNoti() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            
            
            // Enable or disable features based on the authorization.
        }
    }
    func handlerDidSelectSettingsOption(for settingsOption: SettingsOption) {
        switch settingsOption {
            
        case .LocalSaved:
            let localSavedVC = LocalSavedVC()
            navigationController?.pushViewController(localSavedVC, animated: true)
        case .LinkAccount:
            break
        case .SendNoti:
            break
        }
    }
    
    //MARK: - Selector
    @objc func handlerClose() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}
