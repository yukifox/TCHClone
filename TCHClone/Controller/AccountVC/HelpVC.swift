//
//  HelpVC.swift
//  TCHClone
//
//  Created by Trần Huy on 5/27/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import WebKit
class WebView: UIViewController {
    //MARK: - Properties
    var myProgess = UIProgressView()
    let btnOrder: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundColor(.orange, for: .normal)
        btn.clipsToBounds = true
        btn.setTitle("Order ngay", for: .normal)
        btn.addTarget(self, action: #selector(btnOrderTapped), for: .touchUpInside)
        return btn
    }()
    var url: URL?
    enum TypeViewing {
        case viewFromNavigationView
        case viewFromNormalView
    }
    var keepTabbar: Bool = true
    var keepNavigationBar: Bool = true
    var typeViewing: TypeViewing = .viewFromNavigationView
    var showOrderButton: Bool = false {
        didSet {
            btnOrder.isHidden = !showOrderButton
        }
    }
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureWebView()
        
    }
    
    //MARK: - Handler
    func configureWebView() {
        let webview = UIWebView(frame: view.frame)
        view.addSubview(webview)
        webview.delegate = self
        let request = URLRequest(url: url!)
        webview.loadRequest(request)
        
        view.addSubview(btnOrder)
        btnOrder.setAnchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, height: 50)
        btnOrder.layer.cornerRadius = 25
        view.addSubview(myProgess)
        myProgess.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 2)
        myProgess.backgroundColor = .clear
        myProgess.progressTintColor = .orange
        
    }
    func configureNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "node_modules_reactnavigation_src_views_assets_backicon-1"), style: .done, target: self, action: #selector(backToPreviousVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "resources_images_icons_ic_share"), style: .plain, target: self, action: #selector(sharelink))
    }
    
    //MARK: - Selector
    @objc func btnOrderTapped() {
        backToPreviousVC()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "com.button.order.tapped"), object: nil)
        
    }
    @objc func backToPreviousVC() {
        tabBarController?.tabBar.isHidden = !keepTabbar
        navigationController?.navigationBar.isHidden = !keepNavigationBar
        switch typeViewing {
        case .viewFromNormalView:
            
            self.dismiss(animated: true, completion: {
            })
            break
        case .viewFromNavigationView:
            
            self.navigationController?.popViewController(animated: true)
            break
        }
        
        
        
    }
    @objc func sharelink() {
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityController, animated: true)
    }
}
extension WebView: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.myProgess.setProgress(0.1, animated: false)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.myProgess.setProgress(1, animated: true)
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.myProgess.setProgress(1, animated: true)
    }
}
