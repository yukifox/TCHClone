//
//  MainLoginVC.swift
//  TCHClone
//
//  Created by Trần Huy on 4/29/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class MainLoginVC: UIViewController {
    //MARK: Propertise
    
    let btnLogin: UIButton = {
        let btn = UIButton(type: .system)
        Utilities.styleFilledButton(btn)
        btn.setTitle("Login", for: .normal)
        btn.addTarget(self, action: #selector(handlerLogin), for: .touchUpInside)
        return btn
    }()
    let btnSignUp: UIButton = {
        let btn = UIButton(type: .system)
        Utilities.styleHollowButton(btn)
        btn.setTitle("Sign Up", for: .normal)
        btn.addTarget(self, action: #selector(handlerSignUp), for: .touchUpInside)
        return btn
    }()
    let btnSkip: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Skip", for: .normal)
        btn.addTarget(self, action: #selector(handlerDismiss), for: .touchUpInside)
        return btn
    }()
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Handler
    func setupView() {
        view.backgroundColor = .groupTableViewBackground
        
        
        view.addSubview(btnSkip)
        btnSkip.setAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        btnSkip.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(btnSignUp)
        btnSignUp.setAnchor(top: nil, left: view.leftAnchor, bottom: btnSkip.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 40)
        btnSignUp.layer.cornerRadius = 20
        view.addSubview(btnLogin)
        btnLogin.setAnchor(top: nil, left: view.leftAnchor, bottom: btnSignUp.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 40)
        btnLogin.layer.cornerRadius = 20
    }
    
    //MARK: - Selector
    @objc func handlerDismiss() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handlerLogin() {
//        dismiss(animated: true, completion: nil)
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    @objc func handlerSignUp() {
        let signupVC = SignUpVC()
        signupVC.modalPresentationStyle = .fullScreen
        present(signupVC, animated:  true)
    }
}
