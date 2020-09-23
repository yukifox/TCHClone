//
//  National.swift
//  TCHClone
//
//  Created by Trần Huy on 8/25/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
enum National: String, CaseIterable, CustomStringConvertible {
    case vietnam
    var description: String {
        switch self {
        case .vietnam:
            return "(+84) Việt Nam"
        
        }
    }
    var image: UIImage {
        switch self {
        case .vietnam:
            return #imageLiteral(resourceName: "resources_images_flag_vietnam")
        }
    }
    var code: String {
        switch self {
        case .vietnam :
            return "+84"
        }
    }
    static var allValues: [National] {
        return [.vietnam]
    }
}
