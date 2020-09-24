//
//  Notification.swift
//  TCHClone
//
//  Created by Trần Huy on 9/23/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UserNotifications
enum NotificationIdentifier {
    case inCart
    case fromServer
    var stringIdentifier: String {
        switch self {
        case .inCart:
            return "inCart"
        case .fromServer:
            return "fromSever"
        }
    }
}
class NotificationServices {
    static let shared = NotificationServices()
    init() {
        
    }
    
    func createLocalNotification(title: String, body: String, identifier: NotificationIdentifier) {
        let center = UNUserNotificationCenter.current()
        
        //Create Notification Content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        //Create Notification Trigger
        let date = Date().addingTimeInterval(5
        )
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

        //Create request
        
        let request = UNNotificationRequest(identifier: identifier.stringIdentifier, content: content, trigger: trigger)
        //Register the request
        center.removePendingNotificationRequests(withIdentifiers: [identifier.stringIdentifier])
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            
        })
    }
    
}
