//
//  EnterPhoneNumber.swift
//  TCHClone
//
//  Created by Trần Huy on 8/25/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UIKit
class EnterPhoneNumber: UIView {
    //MARK: - Properties
    let lblWellcome: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        let attributes = NSMutableAttributedString(string: "Chào bạn, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        attributes.append(NSAttributedString(string: "Nhập số điện thoại để tiếp tục", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attributes
        return lbl
    }()
    let popupWindowChooseNation: PopupChooseNation = {
       let v = PopupChooseNation()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        
        return v
    }()
    let btnChoose: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "resources_images_flag_vietnam").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.imageView?.frame = CGRect(origin: .zero, size: CGSize(width: btn.frame.width, height: btn.frame.height))
        btn.layer.borderWidth = 0.2
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .white
        btn.setTitle("▾", for: .normal)
        btn.titleLabel?.textColor = UIColor.darkText
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn.addTarget(self, action: #selector(handlerBtnChooseNationalTapped), for: .touchDown)
        return btn
    }()
    let textPhoneNumber: UITextField = {
       let tf = UITextField()
        
        tf.placeholder = "Enter your phone number"
        tf.layer.borderWidth = 0.2
        tf.layer.cornerRadius = 5
        tf.backgroundColor = .white

//        tf.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlerTextFieldPhoneTapped))
//        tf.superview!.addGestureRecognizer(gesture)
//
        return tf
    }()
    
    var delegate: EnterPhoneViewDelegate?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handlerTextFieldPhoneTapped()
    }
    
    //MARK: - Handler
    
    func initView() {
        addSubview(lblWellcome)
        lblWellcome.setAnchor(top:topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        let stackView = UIStackView(arrangedSubviews: [btnChoose, textPhoneNumber])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing  = 15
        addSubview(stackView)
        stackView.setAnchor(top: lblWellcome.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        textPhoneNumber.isEnabled = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlerTextFieldPhoneTapped))
        textPhoneNumber.addGestureRecognizer(gesture)
    }
    @objc func handlerBtnChooseNationalTapped() {
        delegate?.handlerBtnChooseNationalTapped()
    }
    @objc func handlerTextFieldPhoneTapped() {
        
//        addSubview(popupWindowChooseNation)
//        popupWindowChooseNation.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: popupWindowChooseNation.frame.height)
//        popupWindowChooseNation.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        popupWindowChooseNation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    
}
