//
//  InforAccount.swift
//  TCHClone
//
//  Created by Trần Huy on 9/4/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
class InforAccount: UIViewController {
    
    //MARK: - Properties

    let mainView = UIScrollView()
    let btnClose: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "node_modules_reactnativeflashmessage_src_icons_fm_icon_danger").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(btnCloseTapped), for: .touchUpInside)
        return btn
    }()
    let lblUserName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    let lblDetailUser: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    let headerView: UIView = {
       let view  = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    let imageUser: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        
        return iv
    }()
    let imgBtnEdit = UIImageView()
    let lblInforAccount: UILabel = {
       let lbl = UILabel()
        lbl.text = "Thông tin cá nhân"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let btnChangeInfor: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Đổi", for: .normal)
        btn.titleLabel?.textColor = .blue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(btnEditTapped), for: .touchUpInside)
        return btn
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.estimatedRowHeight = 50
        tv.isScrollEnabled = false
        tv.allowsSelection = false
        tv.backgroundColor = .white
        return tv
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    let viewIndicator: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()

    
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .darkGray, padding: 0)
    
    let loadingText : UILabel = {
       let lbl = UILabel()
        lbl.text = "Loading..."
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    fileprivate var showIndicator = false {
        didSet {
            handlerIndicatorView(showIndicator)
        }
    }
    var userInfor = [String: String]()
    var user: User? {
        didSet {
            configView()
        }
    }
    var keepTabbar: Bool = true
    var keepNavigationBar = false
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.sizeToFit()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellInForAccount")
        initView()
        configView()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Handler
    
    func initView() {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        //main view
        view.addSubview(mainView)
        mainView.backgroundColor = .groupTableViewBackground
        mainView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        mainView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        mainView.addSubview(headerView)
        headerView.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: mainView.frameLayoutGuide.leftAnchor, bottom: nil, right: mainView.frameLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
        headerView.addSubview(imageUser)
        imageUser.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        imageUser.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageUser.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        imageUser.layer.cornerRadius = 40
        headerView.addSubview(imgBtnEdit)
        imgBtnEdit.setAnchor(top: nil, left: nil, bottom: imageUser.bottomAnchor, right: imageUser.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
        headerView.addSubview(lblUserName)
        lblUserName.setAnchor(top: imageUser.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        lblUserName.centerXAnchor.constraint(equalTo: imageUser.centerXAnchor).isActive = true
        headerView.addSubview(lblDetailUser)
        lblDetailUser.setAnchor(top: lblUserName.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        lblDetailUser.centerXAnchor.constraint(equalTo: lblUserName.centerXAnchor).isActive = true
        mainView.addSubview(lblInforAccount)
        lblInforAccount.setAnchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0)
        mainView.addSubview(btnChangeInfor)
        btnChangeInfor.setAnchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15)
        btnChangeInfor.centerYAnchor.constraint(equalTo: lblInforAccount.centerYAnchor).isActive = true
        mainView.addSubview(tableView)
//        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
        tableView.estimatedRowHeight = 50
        tableView.setAnchor(top: lblInforAccount.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: tableView.contentSize.height)
        view.addSubview(btnClose)
        btnClose.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        //indicator
        view.addSubview(visualEffectView)
        visualEffectView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        visualEffectView.alpha = 0
        view.addSubview(viewIndicator)
        viewIndicator.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        viewIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewIndicator.alpha = 0
        viewIndicator.addSubview(indicator)
        indicator.setAnchor(top: viewIndicator.topAnchor, left: viewIndicator.leftAnchor, bottom: nil, right: viewIndicator.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 0, height: 80)
        viewIndicator.addSubview(loadingText)
        loadingText.setAnchor(top: indicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        loadingText.centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
    }
    
    func configView() {
        tableView.layoutSubviews()
        var imageUserUrl: String?
        let type = Auth.auth().currentUser?.providerData.first?.providerID
        if user?.profileImageUrl == nil {
            if type == "facebook.com" {
                imageUserUrl = "http://graph.facebook.com/\(user!.facebookId!)/picture?type=large"
            }
        } else {
            imageUserUrl = user?.profileImageUrl
        }
        
        imageUser.loadImage1(with: imageUserUrl!)
        imgBtnEdit.layer.cornerRadius = 9
        imgBtnEdit.clipsToBounds = true
        imgBtnEdit.image = #imageLiteral(resourceName: "editbtn")
        imgBtnEdit.contentMode = .scaleAspectFit
        mainView.showsVerticalScrollIndicator = false
        mainView.setContentOffset(.zero, animated: true)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imgUserTapped))
        imageUser.isUserInteractionEnabled = true
        imageUser.addGestureRecognizer(gesture)
        lblUserName.text = user?.name ?? user?.fbname
        let attributes = NSMutableAttributedString(string: "\(user!.points ?? 0) ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.orange])
//        let imageAttachment = NSTextAttachment(image: #imageLiteral(resourceName: "resources_images_icons_bean").withRenderingMode(.alwaysOriginal))
        
//        let imageString = NSAttributedString(attachment: imageAttachment)
        attributes.addImageAttachment(image: #imageLiteral(resourceName: "resources_images_icons_bean"), font: UIFont.systemFont(ofSize: 13), textColor: .brown, size: CGSize(width: 18, height: 13))
        attributes.append(NSAttributedString(string: " ⎮ \(user!.userLever())", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))
        lblDetailUser.attributedText = attributes
        if let name = user?.name ?? user?.fbname {
            userInfor["Tên"] = name
        }
        if let birthDay = user?.birthDay {
            userInfor["Ngày sinh"] = birthDay
        }
        if let phone = user?.phone {
            userInfor["Số điện thoại"] = phone
        }
        if let mail = user?.email {
            userInfor["Email"] = mail
        }
        if let sex = user?.sex {
            userInfor["Giới tính"] = sex
        }
        tableView.reloadData()
    }
    
    //MARK: - Selector
    @objc func btnCloseTapped() {
        self.tabBarController?.tabBar.isHidden = !keepTabbar
        self.navigationController?.navigationBar.isHidden = !keepNavigationBar
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imgUserTapped() {
        let alert = UIAlertController(title: "Thay đổi Avatar", message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Chụp ảnh mới", style: .default, handler: {( _) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated:  true)
        })
        
        let choosePhotoAction = UIAlertAction(title: "Chọn từ thư viện", style: .default, handler: {(aler) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated:  true)
        })
        let cancelAction = UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: nil)
        alert.addAction(takePhotoAction)
        alert.addAction(choosePhotoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func btnEditTapped() {
        let editInforVC = EditInforVC()
        editInforVC.delegate = self
        editInforVC.user = user
        self.navigationController?.pushViewController(editInforVC, animated: true)
    }
    
    //MARK: - Handler
    func handlerUpdatePhoto() {
        guard let uid = user?.uid else { return }
        DispatchQueue.main
    }
    
    func handlerIndicatorView(_ show: Bool) {
        
        if show {
            visualEffectView.alpha = 0.4
            viewIndicator.alpha = 1
            indicator.startAnimating()
            
        } else {
            visualEffectView.alpha = 0
            viewIndicator.alpha = 0
            indicator.stopAnimating()
        }
    }
}

extension InforAccount: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfor.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellInForAccount", for: indexPath)
        
        cell.textLabel?.numberOfLines = 2
        let attributes = NSMutableAttributedString(string: "\(userInfor[indexPath.row].key) \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributes.append(NSAttributedString(string: userInfor[indexPath.row].value, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        cell.textLabel!.attributedText = attributes
        
        return cell
    }
}
extension InforAccount: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        //set image edited
        guard let editedImage = info[.editedImage] as? UIImage else { return }
        
        //compress to upload data
        
        guard let uploadData = editedImage.jpegData(compressionQuality: 0.5) else { return }
        
        //upload image
        let filename = NSUUID().uuidString
        //Delete old image
        
        //
        showIndicator = true
        let storageRef = Storage.storage().reference().child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            storageRef.downloadURL(completion: {(url, error) in
                if let err = error {
                    print(err.localizedDescription)
                }
                let profileURL = url?.absoluteString
                //get uid
                let uid = self.user!.uid
                //create dictionary to update
                let dictionaryValue = ["imageProfileURL": profileURL] as! Dictionary<String, Any>
                
                //Upload to database
                Database.database().reference().child("users").child(uid!).updateChildValues(dictionaryValue, withCompletionBlock: {(error, dataRef) in
                    self.showIndicator = false
                    self.imageUser.image = editedImage
                    self.user?.profileImageUrl = profileURL
                    NotificationCenter.default.post(name: Notification.Name("userInfoChanged"), object: nil)
                })
            })
        })
        
        
    }
}

extension InforAccount: EditInforDelegate {
    func updateUser(user: User) {
        self.user = user
//        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Thông báo", message: "Bạn đã cập nhật thông tin thành công!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
                self.present(alert, animated: false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.user.change.success"), object: nil)
        }
        self.configView()
    }
}
