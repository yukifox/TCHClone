//
//  PostData+CoreDataProperties.swift
//  
//
//  Created by Trần Huy on 6/2/20.
//
//

import Foundation
import CoreData


extension PostData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostData> {
        return NSFetchRequest<PostData>(entityName: "PostData")
    }

    @NSManaged public var createdAt: Int32
    @NSManaged public var descriptionPost: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: Data?
    @NSManaged public var link: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var order: Bool

}
