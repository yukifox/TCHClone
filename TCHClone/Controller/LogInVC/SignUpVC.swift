//
//  SignUpVC.swift
//  TCHClone
//
//  Created by Trần Huy on 5/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField


class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - properties
    var imageSelected = false
    var uid: String?
    var isUpdatePhoneNumber = false {
        didSet {
            btnSignup.setTitle(isUpdatePhoneNumber ? "Cập nhật thông tin" : "Đăng kí", for: .normal)
        }
    }
    let imgHeader: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pattern")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    
    let tfName: SkyFloatingLabelTextField = {
        let tf = Utilities.styleTextField(with: "Your Name")
        tf.textContentType = .name
        return tf
    }()
    
    let tfEmail: SkyFloatingLabelTextField = {
        let tf = Utilities.styleTextField(with: "Your Email")
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
        
    let tfPassword: SkyFloatingLabelTextField = {
        let tf = Utilities.styleTextField(with: "Password")
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .allCharacters
        return tf
    }()
    
    let btnPhoto: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "resources_images_icons_ic_add"), for: .normal)
        btn.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return btn
    }()
    let btnSignup: UIButton = {
        let btn = UIButton(type: .system)
        Utilities.styleFilledButton(btn)
        btn.backgroundColor = UIColor(red: 255/255, green: 0.5, blue: 0/255, alpha: 0.9)

        btn.addTarget(self, action: #selector(handlerSignUp), for: .touchUpInside)
        return btn
    }()
    let lblErr: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    
    let btnCancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(btnCancelTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var containerviewSignUpView: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.addSubview(btnCancel)
        btnCancel.setAnchor(top: nil, left: nil, bottom: v.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        btnCancel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        v.addSubview(btnSignup)
        btnSignup.setAnchor(top: nil, left: v.leftAnchor, bottom: btnCancel.topAnchor, right: v.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 40)
        v.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        return v
        
    }()
    var tfBirthday: SkyFloatingLabelTextField = {
       let tf = SkyFloatingLabelTextField()
        tf.placeholder = "Enter your birthday"
        
        return tf
    }()
    
    private var dd = 0      // The day for testing
    private var mm = 0      // The month for testing
    private var yyyy = 0    // The year for testing
    private var hh = 0      // The hour for testing
    private var mn = 0      // The minutes for testing

    let yearMini = 1        // Allow range from 1 to 2099
    let yearMaxi = 2099
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configNavigationBar()
        tfBirthday.delegate = self
    }
    
    //MARK: - Selector
    @objc func handleAddPhoto() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true)
        
    }
    @objc func showLoginVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlerSignUp() {
        let err = self.validateTextFiel()
        if err != "" {
            showErr(errText: err)
            return
        }
        showErr(errText: err)
        
        //get all information
        guard let name = tfName.text else { return }
        guard let email = tfEmail.text else { return }
        guard let birthDay = tfBirthday.text else { return }
        
         let password = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !isUpdatePhoneNumber {
            Auth.auth().createUser(withEmail: email, password: password!, completion: {(user, error) in
                if let err = error {
                    self.showErr(errText: err.localizedDescription)
                    return
                }
                //set image profile
                guard let imgProfile = self.btnPhoto.imageView?.image else { return }
                //compress to upload data
                guard let uploadData = imgProfile.jpegData(compressionQuality: 0.4) else { return }
                //upload image
                let filename = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_image").child(filename)
                storageRef.putData(uploadData, metadata: nil, completion: {(metadata, err) in
                    if let err = err {
                        self.showErr(errText: err.localizedDescription)
                    }
                    storageRef.downloadURL(completion: {(url, error) in
                        if let err = error {
                            self.showErr(errText: err.localizedDescription)
                        }
                        let profileURL = url?.absoluteString
                        //get uid
                        let uid = user?.user.uid
                        //create dictionary to save
                        let dictionaryValues = [
                            "fullname": name,
                            "imageProfileURL": profileURL,
                            "birthDay": birthDay,
                            "email": email,
                            "points": 0
                        ] as Dictionary<String, Any>
                        let value = [uid: dictionaryValues]
                        
                        //Upload to database
                        Database.database().reference().child("users").updateChildValues(value, withCompletionBlock: { [weak self] (error, dataRef) in
                            guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController else { return }
                            mainTabVC.configureViewController()
                            self?.dismiss(animated: true, completion: nil)
                        
                        })
                    })
                })
                
            })
        } else {
            //set image profile
            guard let imgProfile = self.btnPhoto.imageView?.image else { return }
            //compress to upload data
            guard let uploadData = imgProfile.jpegData(compressionQuality: 0.4) else { return }
            //upload image
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, err) in
                if let err = err {
                    self.showErr(errText: err.localizedDescription)
                }
                storageRef.downloadURL(completion: {(url, error) in
                    if let err = error {
                        self.showErr(errText: err.localizedDescription)
                    }
                    let profileURL = url?.absoluteString
                    //get uid
                    let uid = self.uid
                    //create dictionary to save
                    let dictionaryValues = [
                        "fullname": name,
                        "imageProfileURL": profileURL,
                        "birthDay": birthDay,
                        "email": email
                    ] as Dictionary<String, Any>
                    let value = [uid: dictionaryValues]
                    
                    //Upload to database
                    Database.database().reference().child("users").child(uid!).updateChildValues(dictionaryValues, withCompletionBlock: { [weak self] (error, dataRef) in
                        guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabViewController else { return }
                        mainTabVC.configureViewController()
                        self?.dismiss(animated: true, completion: nil)
                    
                    })
                })
            })
        }
        
        
        
    }
    @objc func tfBirthdayValidate() {
        
    }
    
    
    @objc func formValidation() {
        guard
            imageSelected,
            tfName.hasText,
            tfEmail.hasText
            else {
//                btnSignup.isEnabled = false
                btnSignup.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0/255, alpha: 0.9)
                return
        }
        btnSignup.isEnabled = true
        btnSignup.backgroundColor = UIColor.orange
    }
    
    @objc func btnCancelTapped() {
        if isUpdatePhoneNumber {
            try! Auth.auth().signOut()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Handler
    
    func initView() {
        view.backgroundColor = .white
        
        view.addSubview(btnPhoto)
        btnPhoto.setAnchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        btnPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        let stackView = UIStackView()
        if isUpdatePhoneNumber {
            tfPassword.alpha = 0
        } else {
            tfPassword.alpha = 1
        }
        let stackView = UIStackView(arrangedSubviews: [tfName, tfEmail, tfBirthday, tfPassword, lblErr, ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.setAnchor(top: btnPhoto.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func configNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "node_modules_reactnavigation_src_views_assets_backicon-1"), style: .done, target: self, action: #selector(backToPreviousVC))
    }
    
    func validateTextFiel() -> String {
        let cleanedEmail = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(email: cleanedEmail) == false {
            return "Please re-enter your email"
        }
        let cleanedPassword = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isUpdatePhoneNumber {
            if Utilities.isPasswordValid(cleanedPassword!) == false {
                return "Please re-enter password"
                
            }
        }
        return ""
    }
    
    func showErr(errText: String) {
        lblErr.text = errText
        lblErr.alpha = 1
    }
    
    //MARK: - Selector
    @objc func backToPreviousVC() {
        if !isUpdatePhoneNumber {
            self.navigationController?.navigationBar.isHidden = true
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Override Method
    
    override var inputAccessoryView: UIView? {
        get {
            return containerviewSignUpView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    
}

extension SignUpVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageProfile = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        //config Photobtn with selected image
        btnPhoto.layer.cornerRadius = btnPhoto.frame.width / 2
        btnPhoto.layer.masksToBounds = true
        imageSelected = true
        btnPhoto.setImage(imageProfile.withRenderingMode(.alwaysOriginal), for: .normal)
        self.formValidation()
        self.dismiss(animated: true, completion: nil)

    }
}
extension SignUpVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tfBirthday = textField as! SkyFloatingLabelTextField
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        
        textField.inputView = picker
        textField.text = formatDateForDisplay(date: picker.date)
    }
    
    @objc func updateDateField(sender: UIDatePicker) {
        tfBirthday.text = formatDateForDisplay(date: sender.date)
    }
    
    func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfBirthday.resignFirstResponder()
        tfName.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
    }
    
}
