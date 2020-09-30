//
//  Notification+CoreDataProperties.swift
//  
//
//  Created by Trần Huy on 9/28/20.
//
//

import Foundation
import CoreData


extension NotificationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationData> {
        return NSFetchRequest<NotificationData>(entityName: "NotificationData")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var body: String?
    @NSManaged public var link: String?
    @NSManaged public var type: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var date: Date?
    @NSManaged public var notiID: String?
    @NSManaged public var isRead: Bool


}
