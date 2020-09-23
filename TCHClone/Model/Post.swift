//
//  Post.swift
//  TCHClone
//
//  Created by Trần Huy on 5/4/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
struct PostResult: Decodable {
    var data_version: Float?
    var results: [Post]
}

struct Post: Decodable {
    var description: String?
    var id: Int32?
    var imageUrl: String?
    var link: String?
    var title: String?
    var type: String?
    var order: Bool?
}

enum StringPostCell: String, CaseIterable, CustomStringConvertible {
    case music
    case specialprefer
    case news
    case coffeelover
    
    var description: String {
        switch self {
        
        case .music:
            return "Nhạc đang phát tại nhà"
        case .specialprefer:
            return "Ưu đãi đặc biệt"
        case .news:
            return "Cập nhật từ nhà"
        case .coffeelover:
            return "#CofeeLover"
        }
    }
    
}


