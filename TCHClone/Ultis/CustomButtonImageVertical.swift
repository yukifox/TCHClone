//
//  CustomButtonImageVertical.swift
//  TCHClone
//
//  Created by Trần Huy on 5/22/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class CustomButtonImageVertical: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
//            self.frame = CGRect(origin: .zero, size: .zero)
            let imageSize:CGSize = (imageView?.frame.size)!
            let labelString = NSString(string: self.titleLabel!.text!)

            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height - 6), left: 0, bottom: 0, right: -titleSize.width)
            titleEdgeInsets = UIEdgeInsets(top: 6, left: -imageSize.width, bottom: -imageSize.height, right: 0)

            
            
            
//            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + 2), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
        
    }
}
