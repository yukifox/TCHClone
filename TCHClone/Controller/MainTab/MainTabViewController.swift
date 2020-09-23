//
//  MainTabViewController.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Reachability
import Alamofire

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    //MARK: - Properties
    let `default` = UserDefaults.standard
    let reachability = try! Reachability()
    let miniView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    let lblNotice: UILabel = {
       let lbl = UILabel()
        lbl.text = "Không có kết nối mạng!"
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .white
        return lbl
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getDataVersion()
        
        // Do any additional setup after loading the view.
    }
    

    func configureViewController() {
        
        //View when lost connection
        
        reachability.whenReachable = { reachability in
            self.miniView.alpha = 0
        }
        reachability.whenUnreachable = { _ in
            self.miniView.alpha = 1
        }
        try! reachability.startNotifier()
        view.addSubview(miniView)
        miniView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 19)
        miniView.addSubview(lblNotice)
        lblNotice.translatesAutoresizingMaskIntoConstraints = false
        lblNotice.centerXAnchor.constraint(equalTo: miniView.centerXAnchor).isActive = true
        lblNotice.centerYAnchor.constraint(equalTo: miniView.centerYAnchor).isActive = true
        //home news view controller
        let newsVC = configNavTabBarController(unselectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_news_24px_black"), selectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_news_24px_organce"), title: "Tin tức", rootViewController: NewsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        //Order view controller
        let orderVC = configNavTabBarController(unselectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_delivery_24px_black"), selectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_delivery_24px_organce"), title: "Đặt hàng", rootViewController: OrderVC())
        //Store view controller
        let storeVC = configNavTabBarController(unselectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_store_24px_black"), selectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_store_24px_organce"), title: "Cửa hàng", rootViewController: StoreVC())
        //Account view controller
        let accountVC = configNavTabBarController(unselectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_person_24px_black"), selectedImage: #imageLiteral(resourceName: "resources_images_icons_ic_person_24px_organce"), title: "Tài khoản", rootViewController: AccountVC())
        viewControllers = [newsVC, orderVC, storeVC, accountVC]
        tabBar.tintColor = .orange
    }
    
    
    func getDataVersion() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        guard let url = EndPoint(rawValue: "getDataVersion")?.urlPath else { return }
        let queue = DispatchQueue(label: "com.TCHClone", qos: .background, attributes: .concurrent)
        AF.request(url).response(queue: queue, completionHandler: {(data) in
            guard let data = data.data else { return }
            do {
                let decode = JSONDecoder()
                let versionData = try decode.decode(DataVersion.self, from: data)
                let dict: [String: Float] = ["itemDataVersion" : versionData.itemsVersion,
                                 "postDataVersion" : versionData.newsVersion
                ]
                self.`default`.set(dict, forKey: "versionData")
                
            } catch {
                
            }
        })
        
        
    }
    
    func configNavTabBarController(unselectedImage: UIImage, selectedImage: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .orange
        navController.tabBarItem.title = title
        return navController
    }
//    func configureB

}
