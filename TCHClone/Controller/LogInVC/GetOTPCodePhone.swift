//
//  GetOTPCodePhone.swift
//  TCHClone
//
//  Created by Trần Huy on 8/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Firebase
class GetOTPCodePhoneVC: UIViewController {
    
    //MARK: -Properties
    var phoneNumber: String = "" {
        didSet {
            let phone = phoneNumber.replacingOccurrences(of: National.vietnam.code, with: "0", options: .literal, range: nil)
            lblText.text = "Nhập mã xác thực gồm 6 chữ số đã được gửi tới số điện thoại \(phone) để tiếp tục "
        }
    }

    let lblText: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 13)
        
        return lbl
    }()
    let textOTP: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .decimalPad
        tf.placeholder = "Enter your OTP number"
        tf.layer.borderWidth = 0.2
        tf.layer.cornerRadius = 5
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tf.textContentType = .oneTimeCode
        tf.backgroundColor = .white
        return tf
    }()
    
    
    let btnCancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(btnCancelTapped), for: .touchUpInside)
        return btn
    }()
    lazy var containerHandlerLogIn: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.addSubview(btnCancel)
        btnCancel.setAnchor(top: nil, left: nil, bottom: v.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        btnCancel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        v.addSubview(btnContinue)
        btnContinue.setAnchor(top: nil, left: v.leftAnchor, bottom: btnCancel.topAnchor, right: v.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 40)
        v.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        return v
    }()
    
    let btnContinue: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Tiếp tục", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 5
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        btn.addTarget(self, action: #selector(handlerSendOTPNumber), for: .touchUpInside)
        return btn
        
    }()
    var verificationID: String?
    
    
    //MARK: -- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configNavigationBar()
        textOTP.delegate = self
    }
    
    //MARK: - Handler
    
    func initView() {
        self.view.backgroundColor = .white
        view.addSubview(lblText)
        lblText.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        view.addSubview(textOTP)
        textOTP.setAnchor(top: lblText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        
        
    }
    func configNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "node_modules_reactnavigation_src_views_assets_backicon-1"), style: .done, target: self, action: #selector(backToPreviousVC))
    }
    
    //MARK: - Selector
    @objc func handlerSendOTPNumber() {
        guard let verificationCode = textOTP.text else {
            return
        }
        
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! , verificationCode: verificationCode)
//
        Auth.auth().signInAndRetrieveData(with: credential, completion: {(userDataCallback, error) in
            if let err = error {
                return
            }
            guard let uid = userDataCallback?.user.uid else { return }
            guard let phone = userDataCallback?.user.phoneNumber else { return }
            let dictionaryValues = ["phone": phone] as Dictionary<String, Any>
            let value = [uid: dictionaryValues]
            
            //Update to databes
            DB_REF.child("users").child(uid).updateChildValues(dictionaryValues, withCompletionBlock: {(error, data) in
                //RetrieveData
                USER_REF.child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    let uid = snapshot.key
                    guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                    let user = User(uid: uid, dictionary: dictionary)
                    if user.name != nil {
                        guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController else { return }
                        mainTabVC.configureViewController()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let updateInforVC = SignUpVC()
                        updateInforVC.isUpdatePhoneNumber = true
                        updateInforVC.uid = uid
                        self.navigationController?.pushViewController(updateInforVC, animated: true)
                    }
                    
                })
            })
            
        })
    }
    
    @objc func backToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnCancelTapped() {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.setValue(nil, forKey: "userID")

    }
    
    //View view send OTP
    override var inputAccessoryView: UIView? {
        return containerHandlerLogIn
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}

extension GetOTPCodePhoneVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let curText = textOTP.text ?? ""
        
        guard let stringRange = Range(range, in: curText) else {
            return false
        }
        print(stringRange)
        let updateText = curText.replacingCharacters(in: stringRange, with: string)
        print(updateText)
        if textOTP.text!.count >= 6 {
            handlerSendOTPNumber()
            textOTP.resignFirstResponder()
        }
        return updateText.count < 7
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlerSendOTPNumber()
        textField.resignFirstResponder()
        return true
    }
}
