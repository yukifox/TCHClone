//
//  LoginVC.swift
//  TCHClone
//
//  Created by Trần Huy on 5/1/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FBSDKLoginKit
import NVActivityIndicatorView
class LoginVC: UIViewController {
    
//    var didLoginHandler: (() -> ())?
    var signedUpHandler: ((String) -> Void)? = nil

    
    //MARK: - Properties
    
    
    let lblWellcome: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        let attributes = NSMutableAttributedString(string: "Chào bạn, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        attributes.append(NSAttributedString(string: "Nhập số điện thoại để tiếp tục", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attributes
        return lbl
    }()
    let imgHeader: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pattern")
        iv.contentMode = .scaleToFill
        
        return iv
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
        
        tf.addTarget(self, action: #selector(handlerTextFieldPhoneTapped), for: .touchDown)
        
        return tf
    }()
    let popupWindowChooseNation: PopupChooseNation = {
       let v = PopupChooseNation()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        return v
    }()
    let popupWindowChooseMethodEmail: PopUpLogInEmail = {
       let v = PopUpLogInEmail()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        return v
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blueEffect = UIBlurEffect(style: .dark)
        let v = UIVisualEffectView(effect: blueEffect)
        return v
    }()
    
    let tfEmail: SkyFloatingLabelTextField = {
        let tf = Utilities.styleTextField(with: "Your Email")
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let tfPassword: SkyFloatingLabelTextField = {
        let tf = Utilities.styleTextField(with: "Password")
        tf.textContentType = .password
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    let lblErr: UILabel = {
       let lbl = UILabel()
        lbl.textColor = UIColor.red
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
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
    let btnFacebook: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Facebook", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .systemBlue
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(handlerFacebookLoginTapped), for: .touchUpInside)
        return btn
    }()
    
    
    let btnEmail: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Email", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(btnEmailLogInTapped), for: .touchUpInside)
        return btn
    }()
    let btnDontHaveAccount: UIButton = {
        let btn = UIButton(type: .system)
        let attributes = NSMutableAttributedString(string: "Don't have account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        attributes.append(NSAttributedString(string: "SignUp", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        btn.setAttributedTitle(attributes, for: .normal)
        btn.addTarget(self, action: #selector(showSignUpVC), for: .touchUpInside)
        return btn
    }()
    let btnCancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handlerCancel), for: .touchUpInside)
        return btn
    }()
    let lblNotice: UILabel = {
        let lbl = UILabel()
        lbl.text = "Hoặc đăng nhập bằng"
        lbl.font = UIFont.systemFont(ofSize: UIDevice.setSize(iPhone: 13, iPad: 15))
        return lbl
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        popupWindowChooseNation.delegate = self
        popupWindowChooseMethodEmail.delegate = self
        textPhoneNumber.delegate = self
//        btnFbLogIn.delegate = self
//        btnFbLogIn.isHidden = true
        
    }
    
    //MARK: - Handler
    func configureView() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .groupTableViewBackground
        lblErr.alpha = 0
        view.addSubview(imgHeader)
        imgHeader.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: UIDevice.setSize(iPhone: 170, iPad: 300))
        
        view.addSubview(lblWellcome)
        lblWellcome.setAnchor(top: imgHeader.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 3, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        let stackView = UIStackView(arrangedSubviews: [btnChoose, textPhoneNumber])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing  = 15
        view.addSubview(stackView)
        stackView.setAnchor(top: lblWellcome.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        view.addSubview(btnCancel)
        btnCancel.setAnchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        btnCancel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let stackViewbtnLogIn = UIStackView(arrangedSubviews: [btnFacebook, btnEmail])
        stackViewbtnLogIn.axis = .horizontal
        stackViewbtnLogIn.distribution = .fillEqually
        stackViewbtnLogIn.spacing = 20
        view.addSubview(stackViewbtnLogIn)
        stackViewbtnLogIn.setAnchor(top: nil, left: view.leftAnchor, bottom: btnCancel.topAnchor, right:view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20)
        view.addSubview(lblNotice)
        lblNotice.setAnchor(top: nil, left: nil, bottom: stackViewbtnLogIn.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        lblNotice.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(visualEffectView)
        visualEffectView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        visualEffectView.alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopupChooseNational))
        visualEffectView.addGestureRecognizer(gesture)
        
    }
    
    func traintoMainHome() {
        dismiss(animated: true, completion: nil)
    }
    func showErr(with err:String) {
        lblErr.text = err
        lblErr.alpha = 1
    }
    func validateTextField() -> String {
        let cleanedEmail = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(email: cleanedEmail) == false {
            return "Please re-enter email"
        }
        let cleanedPassword = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword!) == false {
            return "Please re-enter Password"
        }
        return ""
    }
    
    //MARK: - Selector
    @objc func handlerTextFieldPhoneTapped() {
//        let logInPhoneVC = UINavigationController(rootViewController: LogInPhoneVC())
//        logInPhoneVC.modalPresentationStyle = .fullScreen
//        present(logInPhoneVC, animated: true)
        self.navigationController?.pushViewController(LogInPhoneVC(), animated: true)
    }
    
    @objc func dismissPopupChooseNational() {
        handlerCancelBtnPopUpTapped()
    }
    
    @objc func handleLogin() {
        let err = validateTextField()
        if err != "" {
            showErr(with: err)
            return
        }
        showErr(with: err)
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
    @objc func showSignUpVC() {
        let signupVC = SignUpVC()
        signupVC.isUpdatePhoneNumber = false
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @objc func formValidation() {
        guard
            tfEmail.hasText,
            tfPassword.hasText
            else {
                btnLogin.isEnabled = false
                btnLogin.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0/255, alpha: 0.9)
                return
        }
        btnLogin.isEnabled = true
        btnLogin.backgroundColor = UIColor.orange
    }
    @objc func btnEmailLogInTapped() {
        view.addSubview(popupWindowChooseMethodEmail)
        popupWindowChooseMethodEmail.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width / 6 * 4, height: popupWindowChooseMethodEmail.frame.height)
        popupWindowChooseMethodEmail.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupWindowChooseMethodEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupWindowChooseMethodEmail.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0.4
            self.popupWindowChooseMethodEmail.alpha = 1
            self.popupWindowChooseMethodEmail.transform = CGAffineTransform.identity
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
    @objc func handlerBtnChooseNationalTapped() {
        
        
        view.addSubview(popupWindowChooseNation)
        popupWindowChooseNation.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: popupWindowChooseNation.frame.height)
        popupWindowChooseNation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupWindowChooseNation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupWindowChooseNation.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popupWindowChooseNation.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 0.3
            self.popupWindowChooseNation.alpha = 1
            self.popupWindowChooseNation.transform = CGAffineTransform.identity
        })
    }
    @objc func handlerFacebookLoginTapped() {
//        btnFbLogIn.sendActions(for: .touchUpInside)
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: {(result, error) in
            
            if let err = error {
                print("Fail")
                return
            }
            if result!.isCancelled {
                return
            }
            
            guard let accessToken = AccessToken.current else {
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            DispatchQueue.main.async {
                
                
                let indicatorview = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: .darkText, padding: 0)
                indicatorview.translatesAutoresizingMaskIntoConstraints = false
                self.btnFacebook.backgroundColor = .darkGray
                self.btnFacebook.setTitle("", for: .normal)
                indicatorview.isHidden = false
                    self.btnFacebook.addSubview(indicatorview)
                indicatorview.setAnchor(top: self.btnFacebook.topAnchor, left: self.btnFacebook.leftAnchor, bottom: self.btnFacebook.bottomAnchor, right: self.btnFacebook.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
                indicatorview.startAnimating()
                
                
            }
            //Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: {(authResult, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                guard let uid = authResult?.user.uid else { return }
                guard let email = authResult?.user.email else { return }
                guard let fbname = authResult?.user.displayName else { return }
                guard let facebookId = AccessToken.current?.userID else { return }
                
                
                let phone = authResult?.user.phoneNumber
                
                let dictionaryValues = [
                    "fbname": fbname,
                    "email": email,
                    "facebookId": facebookId
                ] as Dictionary<String, Any>
                let value = [uid: dictionaryValues]
                
                //Update to database
                DB_REF.child("users").child(uid).updateChildValues(dictionaryValues, withCompletionBlock: { (error, dataRef) in
                    
                    guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController else { return }
                    mainTabVC.configureViewController()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    
                })
            })
            
        })
    }
    
    
}
extension LoginVC: PopupViewChooseNationalDelegate {
    func handlerCancelBtnPopUpTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.visualEffectView.alpha = 0
            self.popupWindowChooseNation.alpha = 0
            self.popupWindowChooseMethodEmail.alpha = 0
            self.popupWindowChooseMethodEmail.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.popupWindowChooseNation.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {(_ ) in
            self.popupWindowChooseNation.removeFromSuperview()
            self.popupWindowChooseMethodEmail.removeFromSuperview()
        })
    }
}
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
extension LoginVC: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("LogIn")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("LogOut")
    }
}

extension LoginVC: PopupLogInEmailDelegate {
    func handlerLoginBtnTapped() {
        self.navigationController?.pushViewController(LoginEmailVC(), animated: true)
    }
    
    func handlerSignUpBtnTapped() {
        let signUpVC = SignUpVC()
        signUpVC.isUpdatePhoneNumber = false
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
}
