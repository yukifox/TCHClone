//
//  AccountSection.swift
//  TCHClone
//
//  Created by Trần Huy on 5/15/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UIKit
enum AccountSettingSection: Int, CaseIterable, CustomStringConvertible {
    case Rewards
    case Infor
    case Music
    case History
    case Help
    case Setting
    
    var description: String {
        switch self {
            case .Rewards: return "The Coffee House Rewards"
        case .Infor:
            return "Thông tin tài khoản"
        case .Music:
            return "Nhạc đang phát"
        case .History:
            return "Lịch sử đơn hàng"
        case .Help:
            return "Giúp đỡ"
        case .Setting:
            return "Cài đặt"
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .Rewards:
            return #imageLiteral(resourceName: "resources_images_icons_ic_reward")
        case .Infor:
            return #imageLiteral(resourceName: "resources_images_icons_ic_person_24px_black")
        case .Music:
            return UIImage(systemName: "music.note.list")!.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .History:
            return #imageLiteral(resourceName: "resources_images_icons_mission")
        case .Help:
            return #imageLiteral(resourceName: "help")
        case .Setting:
            return #imageLiteral(resourceName: "resources_images_icon_setting")
        }
    }
}
