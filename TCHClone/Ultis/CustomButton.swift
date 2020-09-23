//
//  CustomButton.swift
//  TCHClone
//
//  Created by Trần Huy on 5/1/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.orange : UIColor.white
            
            
        }
    }
    
}
