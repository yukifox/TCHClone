//
//  TitleSectionItem.swift
//  TCHClone
//
//  Created by Trần Huy on 6/12/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class TitleSectionItem: UICollectionReusableView {
    //MARK: - Properties
    var titleHeader: String? {
        didSet {
            lblTitle.text = titleHeader
        }
    }
    var lblTitle: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
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

        backgroundColor = .groupTableViewBackground
        addSubview(lblTitle)
        lblTitle.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 8, paddingRight: 15)
        lblTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
}
