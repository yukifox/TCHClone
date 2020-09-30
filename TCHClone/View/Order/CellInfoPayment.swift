//
//  CellInfoPayment.swift
//  TCHClone
//
//  Created by Trần Huy on 9/23/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class CellInfoPayment: UITableViewCell {

    
    @IBOutlet weak var tfNote: UnderLineTextField!
    @IBOutlet weak var lblAddressDetail: UILabel!
    @IBOutlet weak var lblAddressShort: UILabel!
    @IBOutlet weak var tfPhone: UnderLineTextField!
    @IBOutlet weak var tfName: UnderLineTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tfNote.delegate = self
        tfName.delegate = self
        tfPhone.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension CellInfoPayment: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tfName.resignFirstResponder()
        tfNote.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfName.resignFirstResponder()
        tfPhone.resignFirstResponder()
        tfNote.resignFirstResponder()
    }
}
