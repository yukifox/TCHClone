//
//  NotificationVC.swift
//  TCHClone
//
//  Created by Trần Huy on 9/27/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class NotificationVC: UIViewController {
    
    //MARK: Properties
    var dataStore = DataStore.shared
    var notificationService = NotificationServices.shared
    var listNoti = [NotificationData]() {
        didSet {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            
            mainView.contentSize = CGSize(width: view.frame.width, height: max(tableView.contentSize.height, view.frame.height + 50))
            view.layoutIfNeeded()
        }
    }
    let imageView: UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    let lbl: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let btnBackToMainView: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Quay lại trang chính", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(handlerClose), for: .touchUpInside)
        return btn
    }()
    lazy var viewEmptyNoti: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: .zero))
        view.backgroundColor = .clear
        view.addSubview(imageView)
        imageView.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(lbl)
        lbl.setAnchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.image = #imageLiteral(resourceName: "resources_images_empty_fav_empty")
        lbl.text = "Bạn đang không có thông báo nào"
        view.addSubview(btnBackToMainView)
        btnBackToMainView.setAnchor(top: lbl.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width * 0.85, height: 40)
        btnBackToMainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return view
    }()
    var refreshControl: UIRefreshControl!
    var user: User?
    let mainView = UIScrollView()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        initView()
        fetchListNoti()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationViewCell.self, forCellReuseIdentifier: "CellNotification")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
        tableView.isScrollEnabled = true
        
    }
    
    //MARK: - Handler
    func configNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1").withTintColor(.black), style: .plain, target: self, action: #selector(handlerClose))
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Thông báo"
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "resources_images_icons_ic_news_24px_organce").withTintColor(.orange), style: .plain, target: self, action: #selector(checkUnReadNoti))
        
    }
    func initView() {
        view.addSubview(mainView)
        mainView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        mainView.backgroundColor = .groupTableViewBackground
        refreshControl = UIRefreshControl()
        mainView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        mainView.addSubview(viewEmptyNoti)
        viewEmptyNoti.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        mainView.addSubview(tableView)
        tableView.layoutIfNeeded()
        tableView.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: view.leftAnchor, bottom: mainView.frameLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        tableView.isHidden = true
        
    }
    func fetchListNoti() {
        if user != nil {
            var listNoti = notificationService.getNotification(with: (user?.uid)!)
            
            if listNoti.count > 0 {
                tableView.isHidden = false
                viewEmptyNoti.isHidden = true
                listNoti.sort{$0.date! > $1.date!}
                self.listNoti = listNoti
            } else {
                tableView.isHidden = true
                viewEmptyNoti.isHidden = false
            }
        } else {
            tableView.isHidden = true
            viewEmptyNoti.isHidden = false
        }
    }
    //MARK: - Selector
    @objc func handlerClose() {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func checkUnReadNoti() {
        
    }
    @objc func refreshView() {
        self.fetchListNoti()
        refreshControl.endRefreshing()
    }
    //MARK: - TableView Datasource
}
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNoti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotification", for: indexPath) as! NotificationViewCell
        cell.notiItem = listNoti[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notiItem = listNoti[indexPath.row]
        dataStore.markReadNoti(with: notiItem.notiID as! String, userID: user!.uid as! String)
        self.tableView.reloadData()
    }
    
    
    
    
}
