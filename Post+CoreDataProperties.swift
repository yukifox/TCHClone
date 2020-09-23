//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Trần Huy on 5/29/20.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int32
    @NSManaged public var link: String?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var descriptionPost: String?
    @NSManaged public var type: String?
    @NSManaged public var dayCreate: Int32
    
//    static func insertPost(id: Int32, link: String?, image: Data?, title: String?, descriptionPost: String?, type: String?, dayCreate: Int32)

}
