//
//  StoreController.swift
//  TCHClone
//
//  Created by Trần Huy on 9/13/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class StoreController {
    var reponse: GooglePlacesRespone?
    var listStoreData: [Store] = [Store]()
    static func getAllStore(token: String?, completion: @escaping(GooglePlacesRespone) -> Void) {
        var respone: GooglePlacesRespone?
        let networking = NetworkingServices.shared
        var strGoogleApi = String()
        if let t = token {
            strGoogleApi = EndPoint.nextPageResult.urlPath + "&pagetoken=\(t)"
        } else {
            strGoogleApi = EndPoint.queryStore.urlPath
        }
        networking.request(strGoogleApi, completion: {(result) in
            switch result {
                
            case .success(let data):
                
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(GooglePlacesRespone.self, from: data)
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        } )
        
    }
    
    
}
