//
//  RequestLogInVC.swift
//  TCHClone
//
//  Created by Trần Huy on 5/26/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class RequestLogIn: UIViewController {
    //MARK: - Properties
    var delegate: RequestLogInDelegate?
    let mainView = UIScrollView()
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
    let btnLogIn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(handlerLogInTapped), for: .touchUpInside)
        return btn
        
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
    enum ViewingMode: Int {
        case InFor
        case Rewards
        case History
        
        init(index: Int) {
            switch index {
            case 0:
                self = .Rewards
            case 1:
                self = .InFor
            case 3:
                self = .History
            default:
                self = .History
            }
        }
    }
    
    var viewingMode: ViewingMode!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configView()
        configNavigationTitle()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .groupTableViewBackground
        navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: Handler
    func configView() {
        guard let viewingMode = self.viewingMode else { return }
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(backToLastView))
        
        view.addSubview(imageView)
        imageView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 150, height: 150)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(lbl)
        lbl.setAnchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(btnLogIn)
        btnLogIn.setAnchor(top: lbl.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width * 0.85, height: 40)
        btnLogIn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(btnOrder)
        btnOrder.setAnchor(top: lbl.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width * 0.85, height: 40)
        btnOrder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        switch viewingMode {
        case .InFor:
            imageView.image = #imageLiteral(resourceName: "resources_images_empty_login")
            lbl.text = "Đăng nhập hoặc đăng ký ngay để nhận nhiều ưu đãi"
            btnOrder.isHidden = true
        case .Rewards:
            imageView.image = #imageLiteral(resourceName: "resources_images_empty_login")
            lbl.text = "Đăng nhập hoặc đăng ký ngay để nhận nhiều ưu đãi"
            btnOrder.isHidden = true
        case .History:
            imageView.image = #imageLiteral(resourceName: "resources_images_intro_onboadingbg2")
            lbl.text = "Bạn chưa có đơn hàng nào"
            btnLogIn.isHidden = true
        }
    }
    func configNavigationTitle() {
        guard let viewingMode = self.viewingMode else { return }
        switch viewingMode {
            
        case .InFor:
            navigationItem.title = "Ưu đãi của bạn"
        case .Rewards:
            navigationItem.title = "Chương trình thành viên"
        case .History:
            navigationItem.title = "Lịch sử đơn hàng"
        }
        
    }
    
    //MARK: - Selector
    @objc func backToLastView() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handlerOrderTapped() {
        self.dismiss(animated: true, completion: {() in

        })
//        self.delegate?.handlerOrderTapped()


    }
    @objc func handlerLogInTapped() {
        self.dismiss(animated: false, completion: nil)
        self.delegate?.handlerLoginTapped()
    }
}
