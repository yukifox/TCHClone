//
//  LocalSavedVC.swift
//  TCHClone
//
//  Created by Trần Huy on 9/10/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class LocalSavedVC: UITableViewController {
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    
    //MARK: - Handler
    func configView() {
        view.backgroundColor = .groupTableViewBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellLocal")
        tableView.isScrollEnabled = false
        tableView.layoutIfNeeded()
        tableView.rowHeight = 60
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.frame.size = CGSize(width: view.frame.width, height: tableView.contentSize.height)
        navigationItem.title = "Địa điểm đã lưu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(handlerClose))
        navigationController?.navigationBar.tintColor = .black
    }
    //MARK: - Delegate Tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellLocal", for: indexPath) as! UITableViewCell
        return cell
    }
    
    //MARK: - Selector
    @objc func handlerClose() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
