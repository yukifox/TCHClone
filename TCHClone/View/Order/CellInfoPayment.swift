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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
