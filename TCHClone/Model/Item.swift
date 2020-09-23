//
//  Item.swift
//  TCHClone
//
//  Created by Trần Huy on 5/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation

struct ItemResponse : Decodable{
    var dataVersion: Float?
    var results: [Item]
    
    enum CodingKeys: String, CodingKey {
        case dataVersion = "data_version"
        case results
    }
}

struct Item: Decodable {
    var name: String?
    var imageUrl: String?
    var price: PriceItem?
    var topping: Topping?
    var populated: Bool?
    var id: Int16?
    var descriptionItem: String?
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl
        case populated
        case descriptionItem =  "description"
        case price
        case id
        case topping
        case type
    }
    
    
}

struct Topping: Decodable {
    var espresso: Int?
    var daongam: Int?
    var tranchautrang: Int?
    var extrafoam: Int?
    let saucechocolate: Int?
}

struct PriceItem: Decodable {
    var priceSmall: Int?
    var priceMedium: Int?
    var priceLarge: Int?
    
    enum CodingKeys: String, CodingKey {
        case priceSmall = "smallprice"
        case priceMedium = "mediumprice"
        case priceLarge = "largeprice"

    }
}

enum stringDrinkItem: String, CaseIterable, CustomStringConvertible {
    case coffee
    case iceblended
    case fruittea
    case smoothie
    case macchiato
    case tea
    case coffeepack
    

    
    var description: String {
        switch self {
            
        case .coffee:
            return "Cà phê"
        case .tea:
            return "Choco-Matcha"
        case .iceblended:
            return "Thức uống đá xay"
        case .fruittea:
            return "Trà trái cây"
        case .smoothie:
            return "Thức uống trái cây"
        
        case .macchiato:
            return "Macchiato"
        case .coffeepack:
            return "Cà phê gói"
        }
    }
}
public enum stringTypeFoods: String, CaseIterable, CustomStringConvertible {
    case fastfood
    public var description: String {
        switch self {
        case .fastfood:
            return "Thức ăn nhẹ"
        }
    }
}
enum stringTypeCommon: String, CaseIterable, CustomStringConvertible {
    case commonItems
    var description: String {
        switch self {
        case .commonItems:
            return "Món được yêu thích"
        }
    }
}
enum stringItemInCell: String, CaseIterable, CustomStringConvertible {
    case size
    case topping
    case descriptionItem
    var description: String {
        switch self {
        case .size:
            return "Size"
        case .topping:
            return "Topping"
        case .descriptionItem:
            return "Giới thiệu món"
        }
    }
}
enum stringSizeItem: String, CaseIterable, CustomStringConvertible {
    case smallprice
    case mediumprice
    case largeprice
    var description: String {
        switch self {
        case .smallprice:
            return "Nhỏ"
        case .mediumprice:
            return "Vừa"
        case .largeprice:
            return "Lớn"
        }
    }
}
enum stringToppingItem: String, CaseIterable, CustomStringConvertible {
    case espresso
    case daongam
    case tranchautrang
    case extrafoam
    case saucechocolate
    var description: String {
        switch self {
        case .espresso:
            return "Espresso(1shot)"
        
        case .daongam:
            return "Đào ngâm"
        case .tranchautrang:
            return "Trân châu trắng"
        case .extrafoam:
            return "ExtraFoam"
        case .saucechocolate:
            return "Sauce-Chocolate"
        }
    }
}



//struct SizeItem: Decodable {
//    var
//}
