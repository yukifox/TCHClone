//
//  ItemData+CoreDataProperties.swift
//  
//
//  Created by Trần Huy on 6/13/20.
//
//

import Foundation
import CoreData


extension ItemData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemData> {
        return NSFetchRequest<ItemData>(entityName: "ItemData")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    @NSManaged public var imageData: Data?
    @NSManaged public var populated: Bool
//    @NSManaged public var smallprice: Int32
        public var smallprice: Int? {
            get {
                willAccessValue(forKey: "smallprice")
                defer { didAccessValue(forKey: "smallprice") }
    
                return primitiveValue(forKey: "smallprice") as? Int
            }
            set {
                willChangeValue(forKey: "smallprice")
                defer { didChangeValue(forKey: "smallprice") }
    
                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "smallprice")
                    return
                }
                setPrimitiveValue(value, forKey: "smallprice")
            }
        }
        public var mediumprice: Int? {
            get {
                willAccessValue(forKey: "mediumprice")
                defer { didAccessValue(forKey: "mediumprice") }

                return primitiveValue(forKey: "mediumprice") as? Int
            }
            set {
                willChangeValue(forKey: "mediumprice")
                defer { didChangeValue(forKey: "mediumprice") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "mediumprice")
                    return
                }
                setPrimitiveValue(value, forKey: "mediumprice")
            }
        }
        public var largeprice: Int? {
            get {
                willAccessValue(forKey: "largeprice")
                defer { didAccessValue(forKey: "largeprice") }

                return primitiveValue(forKey: "largeprice") as? Int
            }
            set {
                willChangeValue(forKey: "largeprice")
                defer { didChangeValue(forKey: "largeprice") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "largeprice")
                    return
                }
                setPrimitiveValue(value, forKey: "largeprice")
            }
        }

        public var espresso: Int? {
            get {
                willAccessValue(forKey: "espresso")
                defer { didAccessValue(forKey: "espresso") }

                return primitiveValue(forKey: "espresso") as? Int
            }
            set {
                willChangeValue(forKey: "espresso")
                defer { didChangeValue(forKey: "espresso") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "espresso")
                    return
                }
                setPrimitiveValue(value, forKey: "espresso")
            }
        }
        public var tranchautrang: Int? {
            get {
                willAccessValue(forKey: "tranchautrang")
                defer { didAccessValue(forKey: "tranchautrang") }

                return primitiveValue(forKey: "tranchautrang") as? Int
            }
            set {
                willChangeValue(forKey: "tranchautrang")
                defer { didChangeValue(forKey: "tranchautrang") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "tranchautrang")
                    return
                }
                setPrimitiveValue(value, forKey: "tranchautrang")
            }
        }
        public var extrafoam: Int? {
            get {
                willAccessValue(forKey: "extrafoam")
                defer { didAccessValue(forKey: "extrafoam") }

                return primitiveValue(forKey: "extrafoam") as? Int
            }
            set {
                willChangeValue(forKey: "extrafoam")
                defer { didChangeValue(forKey: "extrafoam") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "extrafoam")
                    return
                }
                setPrimitiveValue(value, forKey: "extrafoam")
            }
        }
        public var saucechocolate: Int? {
            get {
                willAccessValue(forKey: "saucechocolate")
                defer { didAccessValue(forKey: "saucechocolate") }

                return primitiveValue(forKey: "saucechocolate") as? Int
            }
            set {
                willChangeValue(forKey: "saucechocolate")
                defer { didChangeValue(forKey: "saucechocolate") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "saucechocolate")
                    return
                }
                setPrimitiveValue(value, forKey: "saucechocolate")
            }
        }
        @NSManaged public var descriptionItem: String?
        public var daongam: Int? {
            get {
                willAccessValue(forKey: "daongam")
                defer { didAccessValue(forKey: "daongam") }

                return primitiveValue(forKey: "daongam") as? Int
            }
            set {
                willChangeValue(forKey: "daongam")
                defer { didChangeValue(forKey: "daongam") }

                guard let value = newValue else {
                    setPrimitiveValue(nil, forKey: "daongam")
                    return
                }
                setPrimitiveValue(value, forKey: "daongam")
            }
        }
    @NSManaged public var type: String?

}
