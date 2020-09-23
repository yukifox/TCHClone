//
//  Services.swift
//  TCHClone
//
//  Created by Trần Huy on 5/4/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
class Services {
    static let shared = Services()
    let BASE_URL = "https://tchclone.firebaseio.com/news.json"
    func fetchPost(completion: @escaping(Result<[Post], Error>) -> Void) {
        guard let url = URL(string: BASE_URL) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {(data, respon, error) in
            if let err = error{
                completion(.failure(err))
            }
            guard let data = data?.parseData(removeString: "null,") else { return }
            
            do {
                
                let post = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(post))
                
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            }).resume()
    }
    
}
extension Data {
    func parseData(removeString string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else { return nil }
        return data
    }
}
