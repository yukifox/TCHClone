//
//  Store.swift
//  TCHClone
//
//  Created by Trần Huy on 9/12/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import CoreLocation
struct GooglePlacesRespone: Decodable {
    var nextPageToken: String?
    var status: String
    var results: [Store]

    enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case results
        case status
    }

    func canLoadMore() -> Bool {
        if status == "OK" && nextPageToken != nil && nextPageToken?.count ?? 0 > 0 {
            return true
        }
        return false
    }
}
struct Store: Decodable {
    var address: String?
    var geometry: Geometry?
    var name: String?
    var photos: [PhotoData]?
    var plus_code: PlusCode?
    var openingHours : OpenNow?
    var shortAddress: String?
    var town: String = "Quận Bình Tân"
    var city: String = "Hồ Chí Minh"
    
    init() {
        
    }
    
    func getImgUrl() -> String {
        if let photoRef: String = photos![0].photoReference {
            return EndPoint.photoReference.urlPath + photoRef
        }
        return ""
    }
    
    func getShortAddress() -> String {
        let addressArr = address!.components(separatedBy: ",")
        return addressArr[0]
    }
    func getTown() -> String {
        let addressArr = address!.components(separatedBy: ",")
        return addressArr[addressArr.count - 3]
    }

    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case geometry
        case name
        case photos
        case plus_code
        case openingHours = "opening_hours"
//        case shortAddress
    }


    struct Geometry: Decodable {
        var location: Location
    }

    struct Location: Decodable {
        var latitude: Double
        var longtitude: Double

        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longtitude = "lng"
        }
        var location: CLLocation {
            return CLLocation(latitude: self.latitude, longitude: self.longtitude)
        }

        func distance(to location: CLLocation) -> CLLocationDistance {
            return location.distance(from: self.location)
        }
    }

    struct OpenNow: Decodable {
        let open: Bool?
        enum CodingKeys: String, CodingKey {
            case open = "open_now"
        }
    }

}
struct PlusCode: Decodable{
    var compound_code: String
    var global_code: String
}
struct PhotoData: Decodable {
    var photoReference: String
    var height: Double
    var width: Double
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
        case height
        case width
    }
}

//struct Root: Codable {
//    var results: [SearchResult]
//    var status: String
//}
//
//struct SearchResult: Codable {
//    var id: String
//    var icon: String
//    var name: String
//    var placeId: String
//    var reference: String
//    var types: [String]
//    var vicinity: String
//    var geometry: Geometry
//    var photos: [Photo]
//    var openingHours: [String:Bool]?
//}
//
//struct Geometry: Codable  {
//    var location: Location
//}
//
//struct Location: Codable  {
//    var lat: Double
//    var lng: Double
//}
//
//struct Photo: Codable {
//    var height: Double
//    var width: Double
//    var photoReference: String
//}



