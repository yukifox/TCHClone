//
//  InforViewCell.swift
//  TCHClone
//
//  Created by Trần Huy on 6/16/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class InforViewCell: UITableViewCell {
    //MARK: - Properties
    enum ViewingMode: Int {
        case radioButtonMode
        case checkBoxMode
        case noneMode
        init(index: Int) {
            switch index {
            case 0:
                self = .radioButtonMode
            case 1:
                self = .checkBoxMode
            default:
                self = .noneMode
            }
        }
        
    }
    var viewingMode: ViewingMode? {
        didSet {
            initView()
        }
    }
    lazy var hideImageButton: NSLayoutConstraint = {
        let constraint = imageButton.widthAnchor.constraint(equalToConstant: 0)
        constraint.priority = .defaultHigh
        return constraint
    }()
    lazy var anchorTextDescription: NSLayoutConstraint = {
        let constraint = lblText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        constraint.priority = .defaultHigh
        return constraint
    }()
    let lblText: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    let imageButton: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    let lblPrice: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Handler
    func initView() {
        
        backgroundColor = .white
        addSubview(imageButton)
        addSubview(lblText)
        addSubview(lblPrice)
        imageButton.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        lblText.numberOfLines = 0
        lblText.setAnchor(top: topAnchor, left: self.imageButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)
        let descriptionConstraints = [
            lblText.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            lblText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15),
            lblText.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lblText.rightAnchor.constraint(equalTo: rightAnchor, constant: 20)
        ]
        lblPrice.setAnchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        lblPrice.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageButton.centerYAnchor.constraint(equalTo: lblText.centerYAnchor).isActive = true
        switch viewingMode {
        case .radioButtonMode:
            imageButton.image = #imageLiteral(resourceName: "abc_btn_radio_to_on_mtrl_000").withTintColor(.orange, renderingMode: .alwaysOriginal)

            
            break
        case .checkBoxMode:

            imageButton.image = #imageLiteral(resourceName: "checkboxUnSelect").withTintColor(.orange, renderingMode: .alwaysOriginal)

            break
        case .noneMode:
            self.selectionStyle = .none
            hideImageButton.isActive = true
            NSLayoutConstraint.activate(descriptionConstraints)
            break
        case .none:
            
            break
        }
        
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        lblText.font = UIFont.boldSystemFont(ofSize: 15)
        
    }
    
}
