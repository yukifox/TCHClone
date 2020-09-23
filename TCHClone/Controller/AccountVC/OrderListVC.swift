//
//  OrderListVC.swift
//  TCHClone
//
//  Created by Trần Huy on 9/9/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class OrderHistoryVC: UIViewController {
    //MARK: - Protperties
    
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
    
    let btnOrder: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Order Now", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(handlerOrderTapped), for: .touchUpInside)
        return btn
    }()
    var refreshControl: UIRefreshControl!
    var user: User?
    let mainView = UIScrollView()
    var delegate: OrderHistoryDelegate?
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        mainView.refreshControl = refreshControl
    }
    
    //MARK: - Handler
    func initView() {
        view.addSubview(mainView)
        mainView.backgroundColor = .groupTableViewBackground
        mainView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        mainView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        mainView.addSubview(imageView)
        imageView.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        imageView.centerXAnchor.constraint(equalTo: mainView.frameLayoutGuide.centerXAnchor).isActive = true
        mainView.addSubview(lbl)
        lbl.setAnchor(top: imageView.bottomAnchor, left: mainView.frameLayoutGuide.leftAnchor, bottom: nil, right: mainView.frameLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        lbl.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        imageView.image = #imageLiteral(resourceName: "resources_images_empty_history_empty")
        lbl.text = "Bạn chưa có đơn hàng nào"
        mainView.addSubview(btnOrder)
        btnOrder.setAnchor(top: lbl.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width * 0.85, height: 40)
        btnOrder.centerXAnchor.constraint(equalTo: mainView.frameLayoutGuide.centerXAnchor).isActive = true
        
    }
    
    func configNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Lịch sử đơn hàng"
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(backToLastView))
    }
    
    //MARK: - Selector
    @objc func backToLastView() {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.popViewController(animated: true)
        }
        @objc func handlerOrderTapped() {
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.popViewController(animated: false)
            self.tabBarController?.tabBar.isHidden = false
            
            self.delegate?.handlerOrderTapped()


        }
    @objc func refreshView() {
        refreshControl.endRefreshing()
        
    }
}

