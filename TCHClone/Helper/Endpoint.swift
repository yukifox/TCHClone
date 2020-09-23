//
//  DataObject.swift
//  TCHClone
//
//  Created by Trần Huy on 6/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation

enum EndPoint: String {
    case post
    case item
    case queryStore
    case nextPageResult
    case photoReference
    case getDataVersion
    var urlPath: String {
        switch self {
            
        case .post:
            return "https://tchclone.firebaseio.com/news.json"
        case .item:
            return "https://tchclone.firebaseio.com/items.json"
        case .queryStore:
            return "https://maps.googleapis.com/maps/api/place/textsearch/json?input=the%20coffee%20house&inputtype=textquery&language=vi&fields=photos,formatted_address,name,opening_hours&key=\(API_KEY)"
        case .nextPageResult:
            return "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(API_KEY)"
        case .photoReference:
            return "https://maps.googleapis.com/maps/api/place/photo?key=\(API_KEY)&maxwidth=512&photoreference="
        case .getDataVersion:
            return "https://tchclone.firebaseio.com/datasheet.json"

        }
    }
}
