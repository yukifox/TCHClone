//
//  CustomCollectionViewStoreCell.swift
//  TCHClone
//
//  Created by Trần Huy on 9/14/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class CustomCollectionViewStoreCell: UICollectionViewCell {
    
    //MARK: - Properties
    let imageViewPicture: UIImageView = {
       let iv = UIImageView()
        iv.image = UIColor.darkGray.image()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let lblDetail: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 2
        return lbl
    }()
    var dataStore: Store? {
        didSet {
            let attributes = NSMutableAttributedString(string: "\(dataStore!.getTown()) \n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            attributes.append(NSAttributedString(string: "\(dataStore!.getShortAddress())", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
            lblDetail.attributedText = attributes
            
            imageViewPicture.loadImage1(with: dataStore!.getImgUrl())
            
            
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
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        addSubview(lblDetail)
        lblDetail.setAnchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 3, paddingBottom: 3, paddingRight: 5, height: 40)
        addSubview(imageViewPicture)
        imageViewPicture.setAnchor(top: topAnchor, left: leftAnchor, bottom: lblDetail.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        
    }
}
