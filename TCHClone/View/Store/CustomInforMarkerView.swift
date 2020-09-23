//
//  CustomInforMarkerView.swift
//  TCHClone
//
//  Created by Trần Huy on 9/14/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
protocol CustomInforMarkerViewDelegate {
    func viewTapped(dataStore: Store)
}
class CustomInforMarkerView: UIView {
    //MARK: - Properties
    let imageIcon: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "resources_images_icons_logo")
        return iv
    }()
    let lblName: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    let lblAddress: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    var delegate: CustomInforMarkerViewDelegate?
    var storeData: Store? {
        didSet{
            self.lblName.text = storeData?.name
            self.lblAddress.text = storeData?.address
        }
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler
    
    func initView() {
        backgroundColor = .white
        addSubview(imageIcon)
        imageIcon.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        imageIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(lblName)
        lblName.setAnchor(top: topAnchor, left: imageIcon.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        addSubview(lblAddress)
        lblAddress.setAnchor(top: nil, left: imageIcon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    
}
