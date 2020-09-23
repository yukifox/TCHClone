//
//  FBSDKAPIs.swift
//  TCHClone
//
//  Created by Trần Huy on 8/27/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FBSDKAPIs {
    static func getUserPictureProfile() -> String? {
        let connection = GraphRequestConnection()
        var userProfileUrl: String?
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id,name"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get), completionHandler: {(connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if
                let fields = result as? [String:Any],
                let userID = fields["id"] as? String
//                let birthDay = fields["user_birthday"],
//                let name = fields["name"] as? String,
//                let email = fields["email"] as? String

            {
                userProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
                
            }
        })
        connection.start()
        return userProfileUrl
    }
//        GraphRequest(graphPath: "/me", parameters: ["fields": "id,name,birthday"]).start(completionHandler:  {(connection, result, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            if
//                let fields = result as? [String:Any],
//                let userID = fields["id"] as? String,
//                let firstName = fields["first_name"] as? String,
//                let lastName = fields["last_name"] as? String,
//                let email = fields["email"] as? String
//
//            {
//                let facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
//                print("firstName -> \(firstName)")
//                print("lastName -> \(lastName)")
//                print("email -> \(email)")
//                print("facebookProfileUrl -> \(facebookProfileUrl)")
//            }
//
//    })
//    }
    
}
