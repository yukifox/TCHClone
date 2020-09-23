//
//  AccountFooter.swift
//  TCHClone
//
//  Created by Trần Huy on 5/14/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit


class AccountFooter: UITableViewHeaderFooterView {
    //MARK: - Properties
    var delegate: AccountFooterDelegate?
    let btnLogout: UIButton = {
        let btn  = UIButton(type: .system)
        btn.setTitle("Đăng xuất", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handlerLogout), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupContaintView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler
    func setupContaintView() {
        contentView.backgroundColor = .groupTableViewBackground
        contentView.addSubview(btnLogout)
        btnLogout.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0)
//        btnLogout.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    //MARK: - Selector
    @objc func handlerLogout() {
        delegate?.handlerLogout(for: self)
    }
    
}
