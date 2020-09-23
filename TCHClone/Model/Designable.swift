//
//  Designable.swift
//  TCHClone
//
//  Created by Trần Huy on 5/16/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView{
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    @IBInspectable var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    @IBInspectable var borderWidthView: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidthView
        }
    }
}
