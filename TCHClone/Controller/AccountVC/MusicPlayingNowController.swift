//
//  File.swift
//  TCHClone
//
//  Created by Trần Huy on 9/22/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class MusicPlayingNowController: UITableViewController {
    //MARK: - Properties
    let mainView: UIScrollView = {
       let view = UIScrollView()
        view.backgroundColor = .groupTableViewBackground
        return view
    }()
    let viewNowSong: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    let imageSong: UIImageView = {
       let view = UIImageView()
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "image_album")
        return view
    }()
    let lblNameSong: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = .black
        lbl.text = "Dancing With Your Ghost"
        return lbl
    }()
    let lblArtist: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .orange
        lbl.text = "Sasha Sloan"
        return lbl
    }()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        refreshControl?.beginRefreshing()
    }
    //MARK: - Handler
    func initView() {
        self.tabBarController?.tabBar.isHidden = true
        viewNowSong.frame.size = CGSize(width: view.frame.width, height: 400)
        viewNowSong.addSubview(lblNameSong)
        lblNameSong.setAnchor(top: viewNowSong.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        lblNameSong.centerXAnchor.constraint(equalTo: viewNowSong.centerXAnchor).isActive = true
        viewNowSong.addSubview(lblArtist)
        lblArtist.setAnchor(top: lblNameSong.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        lblArtist.centerXAnchor.constraint(equalTo: viewNowSong.centerXAnchor).isActive = true
        viewNowSong.addSubview(imageSong)
        
        imageSong.setAnchor(top: lblArtist.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: viewNowSong.frame.height * 0.6, height: viewNowSong.frame.height * 0.6)
        imageSong.layer.cornerRadius = viewNowSong.frame.height * 0.3
        imageSong.clipsToBounds = true
        imageSong.centerXAnchor.constraint(equalTo: viewNowSong.centerXAnchor).isActive = true
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 30
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellMusicVC")
        tableView.allowsSelection = false
        tableView.tableHeaderView = viewNowSong
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    func configNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(handlerClose))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Nhạc đang phát tại nhà"
    }
    
    
    //MARK: - Selector
    @objc func handlerClose() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @objc func refreshView() {
        refreshControl?.endRefreshing()
    }
    //Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellMusicVC")
        cell.imageView?.image = #imageLiteral(resourceName: "resources_images_empty_card_empty")
        cell.detailTextLabel?.text = "dsad"
        cell.textLabel?.text = "dsadasd"
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tiếp theo"
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    
}
