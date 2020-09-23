//
//  SettingsCell.swift
//  TCHClone
//
//  Created by Trần Huy on 9/9/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

protocol CellType: CustomStringConvertible {
    var containtSwt: Bool { get }
    var containtDisclosureIndicator: Bool { get }
    var image: UIImage { get }
}

enum SettingsOption: Int, CaseIterable, CustomStringConvertible, CellType {
    case LocalSaved
    case LinkAccount
    case SendNoti
    
    var containtSwt: Bool {
        switch self {
        
        case .LocalSaved:
            return false
        case .LinkAccount:
            return false
        case .SendNoti:
            return true
        }
        
    }
    
    var containtDisclosureIndicator: Bool {
        switch self {
        case .LocalSaved:
            return true
        case .LinkAccount:
            return true
        case .SendNoti:
            return false
        }
    }
    
    var description: String {
        switch self {
            
        case .LocalSaved:
            return "Địa điểm đã lưu"
        case .LinkAccount:
            return "Liên kết tài khoản"
        case .SendNoti:
            return "Gửi thông báo"
        }
    }
    var image: UIImage {
        switch self {
            
        case .LocalSaved:
            return #imageLiteral(resourceName: "resources_images_icons_ic_location")
        case .LinkAccount:
            return #imageLiteral(resourceName: "resources_images_icons_ic_profile")
        case .SendNoti:
            return #imageLiteral(resourceName: "PngItem_1799665")
        }
    }
}


class SettingsCell: UITableViewCell {
    // MARK: - Properties
    let lblTitle: UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    
    var cellType: CellType? {
        didSet {
            guard let cellType = cellType else {
                return
            }
            lblTitle.text = cellType.description
            swtControl.isHidden = !cellType.containtSwt
            accessoryType = cellType.containtDisclosureIndicator ? .disclosureIndicator : .none
            imageView?.image = cellType.image
        }
    }
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let selectedView: UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var swtControl: UISwitch = {
       let swt = UISwitch()
        swt.translatesAutoresizingMaskIntoConstraints = false
        swt.addTarget(self, action: #selector(handlerSwt), for: .valueChanged)
        return swt
    }()
    var isEnableNoti: Bool? {
        didSet {
            DispatchQueue.main.async {
                self.swtControl.isOn = self.isEnableNoti!
            }
            
        }
    }
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        checkPriacty()
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: {(_ ) in
            self.checkPriacty()
        })
    }
    @objc func checkPriacty() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            self.isEnableNoti = granted
            
            
            // Enable or disable features based on the authorization.
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        

        
    }
    //MARK: - Handler
    
    func initView() {
        self.setHighlighted(false, animated: true)
        backgroundColor = .groupTableViewBackground
        
        contentView.addSubview(containerView)
        containerView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        if let accessoryView = accessoryView {
            containerView.addSubview(accessoryView)
            accessoryView.translatesAutoresizingMaskIntoConstraints = false
            accessoryView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        }
        if let imageView = imageView {
            containerView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.setAnchor(top: nil, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        }
        
            containerView.addSubview(lblTitle)
            lblTitle.setAnchor(top: nil, left: imageView?.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0)
            lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
            lblTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(swtControl)
        swtControl.setAnchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15)
        swtControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    //MARK: - Selector
    @objc func handlerSwt() {
        guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) else { return }
        
        if UIApplication.shared.canOpenURL(openSettingsURL) {
            UIApplication.shared.open(openSettingsURL, options: [:], completionHandler: nil)
        }
    }
    
}
