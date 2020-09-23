//
//  CellCollectionPostItem.swift
//  TCHClone
//
//  Created by Trần Huy on 9/21/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
protocol CustomNewsCellDelegate {
    func btnOrderNowTapped(with data: PostData)
    func itCellTapped(with data: PostData)
}
class CustomNewsCell: UICollectionViewCell {
    //MARK: - Properties
    var cell: PostData? {
        didSet {
            if let title = cell?.title as? String {
                lblTitle.text = title
            }
            if let description = cell?.descriptionPost as? String {
                lblDetail.text = description
            }
            guard let imgData = cell?.image as? Data else { return }
            if cell!.order {
                btnDetail.setTitle("Order ngay", for: .normal)
            } else {
                btnDetail.setTitle("Chi tiết", for: .normal)
            }
            
            imgPost.image = UIImage(data: imgData)
        }
    }
    let imgPost: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .groupTableViewBackground
        return iv
    }()
    let lblTitle: UILabel = {
       let lbl =  UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let lblDetail: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    lazy var btnDetail: CustomButton = {
        let btn = CustomButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(btnOrderNowTapped), for: .touchUpInside)
        btn.setTitleColor(.white, for: .highlighted)
        
    return btn
    }()
    var delegate: CustomNewsCellDelegate?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomNewsCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler
    func setupCustomNewsCell() {
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(itCellTapped))
        self.addGestureRecognizer(gesture)
        backgroundColor = .white
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        addSubview(imgPost)
        imgPost.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        addSubview(lblTitle)
        lblTitle.setAnchor(top: imgPost.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 10, paddingRight: 15)
        addSubview(btnDetail)
        btnDetail.setAnchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 12, paddingRight: 0, width: 90, height: 28)
        btnDetail.layer.cornerRadius = 14
        addSubview(lblDetail)
        lblDetail.setAnchor(top: lblTitle.bottomAnchor, left: leftAnchor, bottom: btnDetail.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 10, paddingRight: 15)
        
    }
    
    //MARK: - Selector
    @objc func btnOrderNowTapped() {
        if !cell!.order {
//            delegate!.btnOrderNowTapped(with: cell!)
            guard let url = cell!.link else { return }
            let webView = WebView()
            webView.showOrderButton = cell!.order
            webView.typeViewing = .viewFromNormalView
            webView.modalTransitionStyle = .coverVertical
            webView.url = URL(string: url)
            let navigationWebView = UINavigationController(rootViewController: webView)
            navigationWebView.modalPresentationStyle = .fullScreen
            self.window?.rootViewController?.present(navigationWebView, animated: true, completion: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "com.button.order.tapped"), object: nil)
        }
    }
    @objc func itCellTapped() {
//        delegate?.itCellTapped(with: cell!)
        guard let url = cell!.link else { return }
        let webView = WebView()
        webView.showOrderButton = cell!.order
        webView.typeViewing = .viewFromNormalView
        webView.modalTransitionStyle = .coverVertical
        webView.url = URL(string: url)
        let navigationWebView = UINavigationController(rootViewController: webView)
        navigationWebView.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(navigationWebView, animated: true, completion: nil)
        
    }
}

//func itCellTapped(with data: PostData) {
//
//}
//
//func btnOrderNowTapped(with data: PostData) {
//    guard let url = data.link else { return }
//    let webView = WebView()
//    webView.isOrderView = data.order
//    webView.typeViewing = .viewFromNormalView
//    webView.modalPresentationStyle = .fullScreen
//    webView.modalTransitionStyle = .coverVertical
//    webView.url = URL(string: url)
//
//}
