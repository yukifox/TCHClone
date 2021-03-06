//
//  NetworkingServices.swift
//  TCHClone
//
//  Created by Trần Huy on 6/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UserNotifications
import OneSignal
class NetworkingServices: UNNotificationServiceExtension {
    private override init(){}
    static let shared = NetworkingServices()
    
    func request(_ urlPath: String, completion: @escaping(Result<Data, NSError>) -> Void) {
        guard let url = URL(string: urlPath) else { return }
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, respon, error) in
                if let err = error {
                    completion(.failure(err as NSError))
                }
                
                guard let data = data else { return }
                completion(.success(data))
            })
            task.resume()
        }
    }
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let userInfor = request.content.userInfo
        print("Running NotificationServiceExtension: userInfo = \(userInfor.description)")
    }
    
}
