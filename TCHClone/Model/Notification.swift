//
//  Notification.swift
//  TCHClone
//
//  Created by Trần Huy on 9/25/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UserNotifications
struct NotificationGet1 : Codable{
    
    let app_id:String
    let filters:[filters]
    var headings: [String: String] = ["en":"title"]
    var contents: [String: String] = ["en":"message"]
    var subtitle: [String: String] = ["en":"SubTitle"]
    var content_available : Bool

}



struct filters : Codable{
    
    let field:String
    let key:String
    let relation:String
    let value:String
}

class NotificationGet {
    var id: String!
    var message: String!
    var subtitle: String?
    var title: String!
    var sound: UNNotificationSound!
    var linkImg: String?
    var urlLaunching: String?
    var isRead: Bool
    var date: String
    init (infoUser: Dictionary<AnyHashable, Any>, id: String) {
        self.id = id
        if let att = infoUser["att"] as? Dictionary<String, String> {
            if let id = att["id"] {
                self.linkImg = id
            }
        }
        if let custom = infoUser["custom"] as? Dictionary<String, String> {
            if let u = custom["u"] {
                self.urlLaunching = u
            }
        }
        if let aps = infoUser["aps"] as? Dictionary<String, Any> {
            if let sound = aps["sound"] as? String{
                self.sound = sound == "default" ? .default : .none
            }
            if let alert = aps["alert"] as? Dictionary<String, String> {
                if let body = alert["body"] {
                    self.message = body
                }
                if let subtitle = alert["subtitle"] {
                    self.subtitle = subtitle
                }
                if let title = alert["title"] {
                    self.title = title
                }
            }
        }
        if let isRead = infoUser["isRead"] as? Bool {
            self.isRead = isRead
        } else {
            self.isRead = false
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd:MM:yyyy HH:mm"
        let dateString = formatter.string(from: date)
        if let date = infoUser["date"] as? String {
            self.date = date
        } else {
            self.date = dateString
        }
    }
    
}
