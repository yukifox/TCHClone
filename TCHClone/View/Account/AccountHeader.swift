//
//  AccountHeader.swift
//  TCHClone
//
//  Created by Trần Huy on 8/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import FirebaseAuth
class AccountHeader: UITableViewHeaderFooterView {
    //MARK: - Properties
    
    var delegate: AccountHeaderDelegate?
    lazy var viewNoLogin: UIView = {
        let v = UIView()
        v.backgroundColor = .orange
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "resources_images_icons_ic_profile")
        let lbl = UILabel()
        lbl.text = "LogIn"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .white
        
        v.addSubview(iv)
        iv.setAnchor(top: nil, left: v.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        iv.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        v.addSubview(lbl)
        lbl.setAnchor(top: nil, left: iv.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        lbl.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        v.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlerHeaderTappedForLogIn))
        gesture.numberOfTouchesRequired = 1
        v.addGestureRecognizer(gesture)
        return v
    }()
    lazy var viewLogin: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        
        v.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlerHeaderTappedForOpenInfor))
        gesture.numberOfTouchesRequired = 1
        v.addGestureRecognizer(gesture)
        return v
    }()
    let imageDefaulUser: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "resources_images_icons_ic_profile")
        iv.layer.cornerRadius = 15
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    let lblLogIn: UILabel = {
       let lbl = UILabel()
        lbl.text = "LogIn"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .white
        return lbl
    }()
    var user: User? {
        didSet{
            setAccountHeader(for: user)
            
        }
    }
    
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func handlerHeaderTappedForLogIn() {
        delegate?.handlerHeaderAccountLoginTapped(for: self)
    }
    @objc func handlerHeaderTappedForOpenInfor() {
        delegate?.handlerHeaderAccountInforTapped(for: self)
    }
    
    //MARK: - Handler
    func configHeaderNoLogIn() {
        addSubview(viewNoLogin)
        viewNoLogin.alpha = 1
        viewNoLogin.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
    }
    func configHeaderHasLogIn() {
        self.backgroundColor = .groupTableViewBackground
        viewNoLogin.alpha = 0
        var imageUserUrl: String?
        let type = Auth.auth().currentUser?.providerData.first?.providerID
        if user?.profileImageUrl == nil {
            if type == "facebook.com" {
                imageUserUrl = "http://graph.facebook.com/\(user!.facebookId!)/picture?type=large"
            }
        }else {
            imageUserUrl = user?.profileImageUrl
        }
        
        let name = user?.name ?? user?.fbname
        let level = user?.level ?? "new"
        let levelLable = user?.userLever().description
        let levelIcon = UserLevel(rawValue: level)!.image
        
        
        
        let imageUser: CustomImageView = {
           let iv = CustomImageView()
            iv.layer.cornerRadius = self.frame.height / 4
            iv.clipsToBounds = true
            iv.loadImage(with: imageUserUrl!)
            return iv
        }()
        let lblName: UILabel = {
           let lbl = UILabel()
            let attributes = NSMutableAttributedString(string: "\(name!) \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributes.append(NSAttributedString(string: levelLable!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
            lbl.numberOfLines = 0
            lbl.attributedText = attributes
            return lbl
        }()

        let iconLevel: UIImageView = {
           let iv = UIImageView()
            iv.image = levelIcon
            return iv
        }()
        
        self.addSubview(viewLogin)
        viewLogin.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        viewLogin.addSubview(imageUser)
        let heightFrame = self.frame.height
        imageUser.setAnchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: heightFrame / 2 , height: heightFrame / 2)
        imageUser.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        viewLogin.addSubview(iconLevel)
        iconLevel.setAnchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: heightFrame / 3, height: heightFrame / 3)
        iconLevel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewLogin.addSubview(lblName)
        lblName.setAnchor(top: nil, left: imageUser.rightAnchor, bottom: nil, right: iconLevel.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        lblName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setAccountHeader(for user: User?) {
        delegate?.setHeader(for: self)
    }
}
