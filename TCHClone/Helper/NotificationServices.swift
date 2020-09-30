//
//  Notification.swift
//  TCHClone
//
//  Created by Trần Huy on 9/23/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UserNotifications
import OneSignal
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
    var dataStore = DataStore.shared
    var `default` = UserDefaults.standard
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
    func uploadNotification(with notification: [AnyHashable: Any], userId: String, notiId: String) {
        let values = notification
        DB_REF.child("users").child(userId).child("listNoti").child(notiId).updateChildValues(values)
    }
    
    func getNotification(with userID: String) -> [NotificationData] {
        var listNotificationLocal = dataStore.fetchNotiFromData()
        var listNotifromServer = [NotificationGet]()
        DB_REF.child("users").child(userID).child("listNoti").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [AnyHashable : Any] {
            
            for item in dictionary {
                let notiItem = NotificationGet(infoUser: item.value as! [AnyHashable: Any], id: item.key as! String)
                listNotifromServer.append(notiItem)
            }}
            if listNotifromServer.count > listNotificationLocal.count {
                self.dataStore.deleteAllNoti()
                self.dataStore.addNotiData(with: listNotifromServer)
                listNotificationLocal = self.dataStore.fetchNotiFromData()
            }
        })
        return listNotificationLocal
    }
    func receviedNotificationFromServer(with userInfor: [AnyHashable: Any], NotiId: String) {
        let notification = NotificationGet(infoUser: userInfor, id: NotiId)
        dataStore.addNotiData(with: [notification])
        if let uid = self.default.value(forKey: "userID") {
            self.uploadNotification(with: userInfor, userId: uid as! String, notiId: NotiId)}
        
    }
    func markReadNoti(with notiId: String, userID: String) {
        dataStore.markReadNoti(with: notiId, userID: userID)
    }
    
}
