//
//  LoginPhoneVC.swift
//  TCHClone
//
//  Created by Trần Huy on 8/25/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInPhoneVC: UIViewController {
    //MARK: - Properties
    let lblWellcome: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        let attributes = NSMutableAttributedString(string: "Chào bạn, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        attributes.append(NSAttributedString(string: "Nhập số điện thoại để tiếp tục", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attributes
        return lbl
    }()
   let lblErr: UILabel = {
      let lbl = UILabel()
       lbl.textColor = UIColor.red
       lbl.font = UIFont.systemFont(ofSize: 13)
    
       return lbl
   }()
    let popupWindowChooseNation: PopupChooseNation = {
       let v = PopupChooseNation()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        return v
    }()
    let visualEffectView: UIVisualEffectView = {
        let blueEffect = UIBlurEffect(style: .dark)
        let v = UIVisualEffectView(effect: blueEffect)
        return v
    }()
    let btnCancel: UIButton = {
       let btn = UIButton(type: .system)
       btn.setTitle("Cancel", for: .normal)
       btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
       btn.addTarget(self, action: #selector(btnCancelTapped), for: .touchUpInside)
       return btn
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
        tf.keyboardType = .decimalPad
        tf.placeholder = "Enter your phone number"
        tf.layer.borderWidth = 0.2
        tf.layer.cornerRadius = 5
        var string = NSString(stringLiteral: "111111111")
        
        tf.backgroundColor = .white
        return tf
    }()
    let btnContinue: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Tiếp tục", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 6
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handlerSendPhoneNumber), for: .touchUpInside)
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
    
    var verificationId = ""
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        initView()
        popupWindowChooseNation.delegate = self
        
    }
    
    //MARK: - Handler
    func initView() {
        view.backgroundColor = .white
        lblErr.alpha = 0
        
        
        view.addSubview(lblWellcome)
        lblWellcome.setAnchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 3, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        
        view.addSubview(btnChoose)
        btnChoose.setAnchor(top: lblWellcome.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        view.addSubview(textPhoneNumber)
        textPhoneNumber.delegate = self
        textPhoneNumber.setAnchor(top: btnChoose.topAnchor, left: btnChoose.rightAnchor, bottom: btnChoose.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 20)
        view.addSubview(lblErr)
        lblErr.setAnchor(top: textPhoneNumber.bottomAnchor, left: textPhoneNumber.leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        view.addSubview(btnCancel)
        
        view.addSubview(visualEffectView)
        visualEffectView.setAnchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        visualEffectView.alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopupChooseNational))
        visualEffectView.addGestureRecognizer(gesture)
    }
    func configNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "node_modules_reactnavigation_src_views_assets_backicon-1"), style: .done, target: self, action: #selector(backToPreviousVC))
    }
    
    //MARK: - Selector
    @objc func backToPreviousVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @objc func dismissPopupChooseNational() {
        handlerCancelBtnPopUpTapped()
    }
    @objc func btnCancelTapped() {
        self.dismiss(animated: true, completion: nil)
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
    @objc func handlerSendPhoneNumber() {
//        let authId = AuthUIDelegate
//        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
//            self.verificationId = verificationID
//            print("Default ID", verificationID)
//        } else {
//        var phoneNumber: String!
        if let phoneNumber = Utilities.configPhoneNumber(with: National.vietnam, phoneNumber: textPhoneNumber.text) {
            lblErr.alpha = 0
            lblErr.text = ""
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil, completion: {(verificationID, error) in
                if let err = error {
                    print(err.localizedDescription)
                    self.lblErr.text = err.localizedDescription
                    self.lblErr.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                        self.lblErr.text = ""
                        self.lblErr.alpha = 0
                    })
                    return
                }
                self.verificationId = verificationID ?? ""
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                print("Id ----", verificationID)
                //                let setOTPVC = UINavigationController(rootViewController: GetOTPCodePhoneVC())
                let setOTPVC = GetOTPCodePhoneVC()
                
                setOTPVC.verificationID = verificationID
                setOTPVC.phoneNumber = phoneNumber
                setOTPVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(setOTPVC, animated: true)
            })
        } else {
            lblErr.alpha = 1
            lblErr.text = "Vui lòng nhập số điện thoại"
            btnContinue.isEnabled = false
            btnContinue.setBackgroundColor(.darkGray, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.btnContinue.isEnabled = true
                self.btnContinue.setBackgroundColor(.systemOrange, for: .normal)
            })
        }
        
        
//        }
        
    }
    
    
    override var inputAccessoryView: UIView? {
        get {
            return containerHandlerLogIn
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension LogInPhoneVC: PopupViewChooseNationalDelegate {
    func handlerCancelBtnPopUpTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.visualEffectView.alpha = 0
            self.popupWindowChooseNation.alpha = 0
            self.popupWindowChooseNation.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {(_ ) in
            self.popupWindowChooseNation.removeFromSuperview()
        })
    }
}
extension LogInPhoneVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textPhoneNumber.resignFirstResponder()
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textPhoneNumber.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let curText = textField.text ?? ""
        guard let stringRange = Range(range, in: curText) else {
            return false
        }
        let updateText = curText.replacingCharacters(in: stringRange, with: string)
        return updateText.count < 11
    }
}
