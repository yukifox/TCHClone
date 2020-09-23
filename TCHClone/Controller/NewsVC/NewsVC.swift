//
//  NewsVC.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

private let reuseUdentifier = "Cell"
private let cellMusic = "MusicCell"
private let headerIdentifer = "HeaderNews"
class NewsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, NewsHeaderDelegate, NewsVCDelegate {
    //MARK: - Properties
    
    var dictPostData = [String: [PostData]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    let persister = PersistenceService.shared
    var listPost = [PostData]() {
        didSet{
            refactorPostData()
        }
    }
    var dataStore = DataStore.shared
    var whatNews: [PostData] = []
    var news = [PostData]()
    var coffeeLover = [PostData]()
    
    var user: User?
    lazy var imgLogin: CustomImageView = {
       let iv  = CustomImageView()
        iv.image = #imageLiteral(resourceName: "resources_images_icons_ic_person_24px_organce")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    lazy var imgUser: CustomImageView = {
       let iv  = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "resources_images_empty_account").withTintColor(.gray, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        return iv
    }()
    lazy var btnLogin: CustomButton = {
        let btn = CustomButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.addTarget(self, action: #selector(btnLoginTapped), for: .touchUpInside)
        return btn
    }()
    lazy var lblName: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        return lbl
    }()
    lazy var viewNavigation: UIView = {
        let height = navigationController!.navigationBar.frame.height
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: height))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(imgUser)
        imgUser.setAnchor(top: nil, left: v.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        imgUser.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        imgUser.layer.cornerRadius = 20
        v.addSubview(lblName)
        lblName.setAnchor(top: nil, left: imgUser.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        lblName.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        return v
    }()
    let btnNoti: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ic_os_notification_fallback_white_24dp-1"), for: .normal)
        return btn
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchcurUserData()
        configCollectionView()
        fetchPostData()
        configureNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(userInfoDidChange), name: Notification.Name("com.user.change.success"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToOrderView), name: NSNotification.Name(rawValue: "com.button.order.tapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(configViewHasLogout), name: Notification.Name("com.user.logout.success"), object: nil)

        
    }
    
    //MARK: - Handler
    func configCollectionView() {
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.delaysContentTouches = false
        
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: reuseUdentifier)
        let nib = UINib(nibName: "NewsMusicCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellMusic)
        collectionView.register(NewsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
    }
    
    func updateUI() {
        self.collectionView.reloadData()
    }
    func configureNavigationBar() {
        if Utilities.shared.checkIfUserIsLogIn() == false {
            navigationItem.leftBarButtonItems?.removeAll()
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: imgLogin), UIBarButtonItem(customView: btnLogin)]
            
            btnLogin.frame = CGRect(x: imgUser.frame.width, y: 0, width: 70, height: 24)
        } else {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(inforViewTapped))
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewNavigation)
            navigationController?.navigationBar.addGestureRecognizer(gesture)
            
        }
        navigationController?.navigationBar.tintColor = .orange
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_os_notification_fallback_white_24dp-1"), style: .plain, target: self, action: #selector(handlerNoti))
        
    }
    func fetchPostData() {
        let listDataItem = dataStore.fetchPostFromData()
        if listDataItem.count > 0 {
            self.listPost = listDataItem
        }
        if let curPostDataLocalVersion = UserDefaults.standard.object(forKey: "versionPostData") as? Float {
            if let curDataVersion = UserDefaults.standard.object(forKey: "versionData") as? [String: Float] {
                let curPostDataVersion = curDataVersion["postDataVersion"]
                if curPostDataVersion! <= curPostDataLocalVersion {
                    return
                }
            }
        }
        
        DispatchQueue.main.async {
            self.dataStore.deleteAllPostData()
            self.dataStore.requestPostDataAndSave(completion: {(listPostData) in
                self.listPost = listPostData
            })
        }

    }
    func refactorPostData() {
        guard listPost != nil else { return }
        dictPostData = Dictionary<String, [PostData]>()
        for post in listPost {
            let type = String(post.type!)
            if case nil = dictPostData[type]?.append(post) {
                dictPostData[type] = [post]
            }
        }
        
    }
    
    
    func fetchcurUserData(){
        if Utilities.shared.checkIfUserIsLogIn() == true {
            let type = Auth.auth().currentUser?.providerData.first?.providerID
//            let imageUserUrl = FBSDKAPIs.getUserPictureProfile()
            var imgUrl: String?
            guard let curUid = Auth.auth().currentUser?.uid else { return }
            
            USER_REF.child(curUid).observeSingleEvent(of: .value, with: {(snapshot) in
                let uid = snapshot.key
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let user = User(uid: uid, dictionary: dictionary)
                self.user = user
                
                guard
//                    let imgUrl = user.profileImageUrl,
                    let fullName = user.name
                else { return }
                
                if user.profileImageUrl == nil {
                    if type == "facebook.com" {
                        imgUrl = "http://graph.facebook.com/\(user.facebookId!)/picture?type=large"
                    }
                }else {
                    imgUrl = user.profileImageUrl
                }
                
                self.imgUser.loadImage(with: imgUrl!)
                
                
                let attributes = NSMutableAttributedString(string: "\(fullName) \n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
                attributes.append(NSAttributedString(string: "\(user.userLever()) ⎮ ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))
                attributes.addImageAttachment(image: #imageLiteral(resourceName: "resources_images_icons_bean"), font: UIFont.systemFont(ofSize: 13), textColor: .orange, size: CGSize(width: 18, height: 13))
                attributes.append(NSAttributedString(string: " \(user.points!)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))

                    self.lblName.attributedText = attributes
                

            })
        }
    }
    @objc func handlerNoti() {
        do {
            try Auth.auth().signOut()
            
            user = nil
            configureNavigationBar()
            let mainTab = MainTabViewController()
            mainTab.configureViewController()
            self.collectionView.reloadData()
        } catch {
            
        }
    }
    @objc func inforViewTapped() {
        if user != nil {
            let inforAccountVC = InforAccount()
            inforAccountVC.user = user
            inforAccountVC.keepTabbar = true
            inforAccountVC.keepNavigationBar = true
            self.navigationController?.pushViewController(inforAccountVC, animated: true)
        }
    }
    //MARK: - Selector
    @objc func btnLoginTapped() {
        
        let loginVC = UINavigationController(rootViewController: LoginVC())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
//        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func userInfoDidChange() {
        fetchcurUserData()
    }
    @objc func configViewHasLogout() {
        user = nil
        configureNavigationBar()
        configCollectionView()
    }
    
    //MARK: - UIColloectionViewControllerDelegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listPost.count > 0 ? 4 : 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row == 0 ? CGSize(width: view.frame.width, height: 120) : CGSize(width: view.frame.width, height: 320)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMusic, for: indexPath) as!NewsMusicCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseUdentifier, for: indexPath) as! NewsCell
            let posts = self.dictPostData[StringPostCell.allCases[indexPath.item].rawValue]
            cell.posts = posts
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as! NewsHeader
        header.delegate = self
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
}
extension NewsVC {
    func handlerOrderTapped(for header: NewsHeader) {
        self.tabBarController?.selectedIndex = 1
    }
}
extension NewsVC {
    
    @objc func transitionToOrderView() {
        self.tabBarController?.selectedIndex = 1
    }
}



