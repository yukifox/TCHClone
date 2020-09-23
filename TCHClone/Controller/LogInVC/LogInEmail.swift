//
//  LogInEmail.swift
//  TCHClone
//
//  Created by Trần Huy on 8/23/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
class LoginEmailVC: UIViewController {
    
//    var didLoginHandler: (() -> ())?
    
    //MARK: - Properties
    let lblWellcome: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        let attributes = NSMutableAttributedString(string: "Chào bạn, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        attributes.append(NSAttributedString(string: "Mời nhập Email để đăng nhập:", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attributes
        return lbl
    }()
    
    
    let tfEmail: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email của bạn"
        tf.layer.borderWidth = 0.3
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.layer.cornerRadius = 10
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    let lblErrEmail: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    let lblErr: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    let tfPassword: UITextField = {
        let tf = UITextField()
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.placeholder = "Mật khẩu của bạn"
        tf.layer.borderWidth = 0.3
        tf.layer.cornerRadius = 10
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        return tf
    }()
    
    let btnForgotPassword: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Quên mật khẩu", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.textColor = .blue
        return btn
    }()
    lazy var containerHandlerLogIn: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        
        v.addSubview(btnLogin)
        btnLogin.setAnchor(top: nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 40)
        v.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        return v
    }()
    
    let btnLogin: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        Utilities.styleFilledButton(btn)
        btn.backgroundColor = UIColor(red: 255/255, green: 0.5, blue: 0/255, alpha: 0.9)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configNavigationBar()
        
    }
    
    //MARK: - Handler
    func configureView() {
        
        view.backgroundColor = .groupTableViewBackground
        lblErr.alpha = 0
        lblErrEmail.alpha = 0
        view.addSubview(lblWellcome)
        lblWellcome.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        
        let stackView = UIStackView(arrangedSubviews: [tfEmail,lblErrEmail, tfPassword, lblErr, btnForgotPassword])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing  = 1
        view.addSubview(stackView)
        stackView.setAnchor(top: lblWellcome.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        view.addSubview(btnLogin)
        btnLogin.setAnchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        
    }
    func configNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "node_modules_reactnavigation_src_views_assets_backicon-1"), style: .done, target: self, action: #selector(backToPreviousVC))
    }
    
    func showErr(with err:String) {
        lblErr.text = err
        lblErr.alpha = 1
    }
    func validateTextField() -> Bool {
        let cleanedEmail = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(email: cleanedEmail) == false {
            lblErrEmail.alpha = 1
            lblErrEmail.text = "Vui lòng nhập đúng địa chỉ Email"
            return false
        } else {
            lblErrEmail.alpha = 0
            lblErrEmail.text = ""
        }
        let cleanedPassword = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword!) == false {
            lblErr.alpha = 1
            lblErr.text = "Vui lòng nhập đúng mật khẩu"
            return false
        } else {
            lblErr.alpha = 0
            lblErr.text = ""
            return true
        }
        
    }
    override var inputAccessoryView: UIView? {
        get {
            return containerHandlerLogIn
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Selector
    @objc func backToPreviousVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleLogin() {
        
        let resultValidate = validateTextField()
        if !resultValidate {
            return
        }
        guard
            let email = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            else { return }
        //Login
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if let err = error {
                self.showErr(with: err.localizedDescription)
                return
            }
            guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController else { return }
            mainTabVC.configureViewController()
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    
    @objc func handlerCancel() {
        
//        guard let maintabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController else { return }
//        maintabVC.configureViewController()
        let mainVC = MainTabViewController()
        self.dismiss(animated: true, completion: nil)

        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
        present(mainVC, animated: true)

    }
}
extension LoginEmailVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
    }
}
