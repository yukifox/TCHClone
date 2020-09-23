//
//  Ultitiles.swift
//  TCHClone
//
//  Created by Trần Huy on 5/1/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth

class Utilities {
    
    static let shared = Utilities()
    init() {
        
    }
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.orange
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.white
    }
    static func styleHollowButton(_ button: UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        button.layer.cornerRadius = 20
        
        button.tintColor = UIColor.black
    }
    func checkIfUserIsLogIn() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    
    static func styleTextField(with placeholder: String) -> SkyFloatingLabelTextField{
        let tf = SkyFloatingLabelTextField()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: tf.frame.height - 2, width: tf.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.black.cgColor
        tf.borderStyle = .none
        tf.layer.addSublayer(bottomLine)
        tf.placeholder = placeholder
        tf.font = UIFont.systemFont(ofSize: 15)
        
        tf.title = placeholder
        tf.selectedTitleColor = .black
        tf.titleFont = UIFont.systemFont(ofSize: 10)
        tf.title?.lowercased()
        return tf
    }
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordText = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordText.evaluate(with: password)
    }
    static func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    static func configPhoneNumber(with nationalCode: National, phoneNumber: String?) -> String? {
        var phoneResult: String = ""
        guard let phoneNumber = phoneNumber else { return nil}
        switch nationalCode {
        case .vietnam:
            if phoneNumber.count < 9 {
                return nil
            } else {
                if phoneNumber.count == 9 {
                    if phoneNumber.hasPrefix("0") {
                        return nil
                    } else {
                        phoneResult.append(nationalCode.code)
                        phoneResult.append(phoneNumber)
                        return phoneResult
                    }
                } else {
                    if phoneNumber.first != "0" {
                        return nil
                    } else
                    {
                        phoneResult.append(nationalCode.code)
                        phoneResult.append(contentsOf: phoneNumber.dropFirst())
                        return phoneResult
                    }

                }
            }
        }
        
        
    }
    
    func createBtn (withTitle title: String) -> UIButton{
        let btn = UIButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        if btn.isHighlighted {
            btn.layer.borderWidth = 0
        }
        btn.setTitleColor(.white, for: .highlighted)
        return btn
    }
}

