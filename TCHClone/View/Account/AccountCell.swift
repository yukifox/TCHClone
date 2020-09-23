//
//  AccountCell.swift
//  TCHClone
//
//  Created by Trần Huy on 5/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    //MARK: -  Properties
    var delegate: AccountCellDelegate?
    var menucell: AccountSettingSection? {
        didSet {
            lblCell.text = menucell?.description
            imgCell.image = menucell?.image
        }
    }

    
    @IBOutlet weak var lblCell: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
