//
//  PopUpLoginEmail.swift
//  TCHClone
//
//  Created by Trần Huy on 8/25/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class PopUpLogInEmail: UIView {
    //MARK: - Properties
    
    let lblDetail: UILabel = {
       let lbl = UILabel()
        lbl.text = "Đăng nhập qua Email"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    
    let btnCancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.borderWidth = 0.3
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 13
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.backgroundColor = btn.isSelected ? UIColor.orange : UIColor.white
        btn.selectedColor1 = UIColor.orange
        btn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        btn.addTarget(self, action: #selector(btnCancelTapped), for: .touchUpInside)
        return btn
    }()
    let btnLogIn: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 13
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("LogIn", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.backgroundColor = btn.isSelected ? UIColor.orange : UIColor.white
        btn.selectedColor1 = UIColor.orange
        btn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        btn.addTarget(self, action: #selector(btnLogInTapped), for: .touchUpInside)
        return btn
    }()
    let btnSignUp: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 13
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("SignUp", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.backgroundColor = btn.isSelected ? UIColor.orange : UIColor.white
        btn.selectedColor1 = UIColor.orange
        btn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        btn.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return btn
    }()
    let lblNotice: UILabel = {
        let lbl = UILabel()
        lbl.text = "The Coffee House đã ngừng hỗ trợ đăng ký tài khoản bằng email. Bạn có thể tiếp tục đăng nhập bằng tài khoản email đã đăng ký."
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 13)
        
        return lbl
    }()
    let seperatorHeader: UIView = {
       let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }()
    let seperatorFooter: UIView = {
       let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }()
    
    var delegate: PopupLogInEmailDelegate?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler
    func initView() {
        self.backgroundColor = .white
        addSubview(lblDetail)
        lblDetail.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        addSubview(seperatorHeader)
        seperatorHeader.setAnchor(top: lblDetail.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0.3)
        
        addSubview(lblNotice)
        lblNotice.layoutIfNeeded()
        lblNotice.invalidateIntrinsicContentSize()
        let lblNoticeHeight = lblNotice.frame.height
        lblNotice.setAnchor(top: seperatorHeader.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: self.frame.width, height: lblNoticeHeight)
        addSubview(seperatorFooter)
        seperatorFooter.setAnchor(top: lblNotice.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.3)
        addSubview(btnLogIn)
        btnLogIn.setAnchor(top: seperatorFooter.bottomAnchor, left: nil, bottom: nil, right: lblNotice.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        addSubview(btnSignUp)
        btnSignUp.setAnchor(top: seperatorFooter.bottomAnchor, left: nil, bottom: nil, right: btnLogIn.leftAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
        addSubview(btnCancel)
        btnCancel.setAnchor(top: seperatorFooter.bottomAnchor, left: nil, bottom: bottomAnchor, right: btnSignUp.leftAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    //MARK: - Selector
    @objc func btnCancelTapped() {
        delegate?.handlerCancelBtnPopUpTapped()
    }
    
    @objc func btnLogInTapped() {
        delegate?.handlerLoginBtnTapped()
    }
    
    @objc func btnSignUpTapped() {
        delegate?.handlerSignUpBtnTapped()
    }
}
