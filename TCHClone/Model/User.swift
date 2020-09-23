//
//  User.swift
//  TCHClone
//
//  Created by Trần Huy on 5/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name: String!
    var fbname: String!
    var uid: String!
    var profileImageUrl: String!
    var level: String!
    var points: Int!
    var email: String!
    var birthDay: String?
    var facebookId: String?
    var sex: String?
    var phone: String?
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        self.uid = uid
        
        if let name = dictionary["fullname"] as? String {
            self.name = name
        }
        if let profileImgUrl = dictionary["imageProfileURL"] as? String {
            self.profileImageUrl = profileImgUrl
        }
        if let level = dictionary["level"] as? String {
            self.level = level
        }
        if let point = dictionary["points"] as? Int {
            self.points = point
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        if let birthDay = dictionary["birthDay"] as? String {
            self.birthDay = birthDay
        }
        if let facebookId = dictionary["facebookId"] as? String {
            self.facebookId = facebookId
        }
        if let sex = dictionary["sex"] as? String {
            self.sex = sex
        }
        if let phone = dictionary["phone"] as? String {
            self.phone = phone
        }
        if let fbname = dictionary["fbname"] as? String {
            self.fbname = fbname
        }
    }
    func userLever() -> UserLevel {
        let point = self.points
        if point == nil || point! < 100 {
            return UserLevel(rawValue: "new")!
        } else if point! < 200 {
            return UserLevel(rawValue: "bronze")!
        } else if point! < 500 {
            return UserLevel(rawValue: "sliver")!
        } else if point! < 3000 {
            return UserLevel(rawValue: "gold")!
        }
        return UserLevel(rawValue: "diamond")!
    }
    
}

enum UserLevel: String, CaseIterable, CustomStringConvertible {
    
    
    case new
    case bronze
    case silver
    case gold
    case diamond
    
    var description: String {
        switch self {
            
        case .new:
            return "Khách hàng mới"
        case .bronze:
            return "Thành viên Đồng"
        case .silver:
            return "Thành viên Bạc"
        case .gold:
            return "Thành viên Vàng"
        case .diamond:
            return "Thành viên Kim Cương"
        }
        
    }
    var backgroundCardMember: UIImage {
        switch self {
            
        case .new, .bronze:
            return #imageLiteral(resourceName: "resources_images_card_new")
        case .silver, .gold:
            return #imageLiteral(resourceName: "resources_images_card_gold")
        case .diamond:
            return #imageLiteral(resourceName: "resources_images_card_diamond")
        }
    }
    var level: String {
        switch self {
            
        case .new:
            return "Mới"
        case .bronze:
            return "Đồng"
        case .silver:
            return "Bạc"
        case .gold:
            return "Vàng"
        case .diamond:
            return "Kim Cương"
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .new:
            return #imageLiteral(resourceName: "resources_images_icons_bean")
        case .bronze:
            return #imageLiteral(resourceName: "resources_images_icons_bean")
        case .silver:
            return #imageLiteral(resourceName: "resources_images_icons_bean")
        case .gold:
            return #imageLiteral(resourceName: "resources_images_icons_bean")
        case .diamond:
            return #imageLiteral(resourceName: "resources_images_icons_bean")
        }
    }
//    func endow(for value: Int) -> Array<String> {
//        switch value {
//        case 0:
//            return ["Ưu đãi nâng size miễn phí sau đơn đầu tiên."]
//        case 1:
//            return ["Một phần bánh dành tặng bạn ngày sinh nhật", "Đổi ưu đãi trong cửa hàng Rewards Store", "Dành tặng bạn một snack khi mua đơn hàng trên 100k"]
//        case 2:
//            return ["Một phần bánh dành tặng bạn ngày sinh nhật" , "Đổi ưu đãi trong cửa hành Rewards Store", "Ưu đãi mua 2 tặng 1"]
//        case 3:
//            return ["Một phần bánh tặng bạn ngày sinh nhật", "Đổi ưu đãi trong cửa hàng Rewards Store", "Miễn phí một ly cafe truyền thống hoặc 1 ly trà trái cây size M bất kì", "Được đổi các ưu đãi đặc biệt từ TheCoffeeHouse và các đối tác"]
//        default:
//            return ["Một phần bánh tặng bạn ngày sinh nhật", "Đổi ưu đãi trong cửa hàng Rewards Store", "Miễn phí một ly cafe truyền thống hoặc 1 ly trà trái cây size M bất kì", "Được đổi các ưu đãi đặc biệt từ TheCoffeeHouse và các đối tác","Tích luỹ nhanh hơn và nhân hệ số 1.5x"]
//        }
//    }
    var endow: [String] {
        switch self {
            
        case .new:
            return ["Ưu đãi nâng size miễn phí sau đơn đầu tiên."]
        case .bronze:
            return ["Một phần bánh dành tặng bạn ngày sinh nhật", "Đổi ưu đãi trong cửa hàng Rewards Store", "Dành tặng bạn một snack khi mua đơn hàng trên 100k"]
        case .silver:
            return ["Một phần bánh dành tặng bạn ngày sinh nhật" , "Đổi ưu đãi trong cửa hành Rewards Store", "Ưu đãi mua 2 tặng 1"]
        case .gold:
            return ["Một phần bánh tặng bạn ngày sinh nhật", "Đổi ưu đãi trong cửa hàng Rewards Store", "Miễn phí một ly cafe truyền thống hoặc 1 ly trà trái cây size M bất kì", "Được đổi các ưu đãi đặc biệt từ TheCoffeeHouse và các đối tác"]
        case .diamond:
            return ["Một phần bánh tặng bạn ngày sinh nhật", "Đổi ưu đãi trong cửa hàng Rewards Store", "Miễn phí một ly cafe truyền thống hoặc 1 ly trà trái cây size M bất kì", "Được đổi các ưu đãi đặc biệt từ TheCoffeeHouse và các đối tác","Tích luỹ nhanh hơn và nhân hệ số 1.5x"]
        }
    }
    
    
}

