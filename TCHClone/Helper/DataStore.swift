//
//  DataStore.swift
//  TCHClone
//
//  Created by Trần Huy on 6/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Alamofire
import Firebase
var imageDataCache = [String: Data]()
class DataStore: NSObject {
    let persister = PersistenceService.shared
    let networking = NetworkingServices.shared
    let `default` = UserDefaults.standard
    override init() {
        super.init()
    }
    
    static let shared = DataStore()
    var delegate: NewsVCDelegate!
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persister.context, sectionNameKeyPath: #keyPath(PostData.id), cacheName: nil)
        return frc
    }()
    
    
    func fetchItemFromData() -> [ItemData] {
        var data = [ItemData]()
        persister.fetch(ItemData.self, completion: {(objests) in
            data = objests
        })
        
        return data
    }
    func fetchPostFromData() -> [PostData] {
        var data = [PostData]()
        persister.fetch(PostData.self, completion: {(object) in
            data = object
        })
        return data
    }
    func fetchNotiFromData() -> [NotificationData] {
        var data = [NotificationData]()
        persister.fetch(NotificationData.self, completion: {(object) in
            data = object
        })
        return data
    }
    func markReadNoti(with exaclyNotiId: String, userID: String) {
//        let context = persister.context
//        var result = NotificationData(context: context)

    //Predicate
        let predicate = NSPredicate(format: "notiID == %@", exaclyNotiId)

        persister.fetchByPredicate(NotificationData.self, predicate: predicate, completion: {(listResult) in
            let result = listResult[0]
            result.setValue(true, forKey: "isRead")
            print(listResult.count)
        })
        
        let valueDict = ["isRead": true]
        persister.saveContext(completion: {
            USER_REF.child(userID).child("listNoti").child(exaclyNotiId).updateChildValues(valueDict, withCompletionBlock: {(error, _) in
                
            })
        })
    }
    func getDataFromDB(){
        
        do{
            try fetchedResultsController.performFetch()
        }catch(let ex){
            
            print(ex.localizedDescription)
        }
        
    }
    func deleteAllNoti() {
        let context = persister.context
        persister.fetch(NotificationData.self, completion: {(listNoti) in
            for noti in listNoti {
                context.delete(noti)
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        })
    }
    
    func deleteAllPostData() {
        let context = persister.context
        persister.fetch(PostData.self, completion: {(listPost) in
            for post in listPost {
                context.delete(post)
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        })
    }
    func deleteAllItemData() {
        let context = persister.context
        persister.fetch(ItemData.self, completion: {(allItemData) in
            for item in allItemData {
                context.delete(item)
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        })
    }
    func addNotiData(with notis: [NotificationGet]) {
        for noti in notis {
            let notiData = NotificationData(context: persister.context)
            notiData.notiID = noti.id
            notiData.title = noti.title
            notiData.subtitle = noti.subtitle
            notiData.body = noti.message
            notiData.isRead = false
            notiData.imgUrl = noti.linkImg
            notiData.link = noti.urlLaunching
            let stringDate = noti.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd:MM:yyyy HH:mm"
            notiData.date = formatter.date(from: stringDate)
            
            persister.saveContext {
                
            }
        }
    }
    func filterItemData(stringSearch: String?) -> [ItemData]? {
        var result = [ItemData]()
        let fetchRequest: NSFetchRequest<ItemData> = ItemData.fetchRequest()
        var subPredicate = [NSPredicate]()
        if stringSearch != nil {
            let predicate = NSPredicate(format: "name contains[cd] %@", stringSearch!)
            subPredicate.append(predicate)
        }
        if subPredicate.count > 0 {
        let compoundPredicates = NSCompoundPredicate.init(type: .and, subpredicates: subPredicate)
            fetchRequest.predicate = compoundPredicates
        }
        do {
            result = try persister.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    func requestItemAndSaveData(completion: @escaping([ItemData]) -> Void) {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        guard let url = EndPoint(rawValue: "item")?.urlPath else { return }
        
        //get data
        
        
        AF.request(url).response(completionHandler: {(responData) in
            guard let data = responData.data?.parseData(removeString: "null,") else { return }
            
            do {
                let itemRespon = try JSONDecoder().decode(ItemResponse.self, from: data)
                let items = itemRespon.results
                
                
                
                items.forEach({(item) in
                    
                    let itemData = ItemData(context: self.persister.context)
                    
                    itemData.id = item.id!
                    itemData.name = item.name
                    itemData.populated = item.populated!
                    itemData.descriptionItem = item.descriptionItem
                    itemData.mediumprice = item.price?.priceMedium
                    itemData.smallprice = item.price?.priceSmall
                    
                    itemData.largeprice = item.price?.priceLarge
                    itemData.daongam = item.topping?.daongam
                    itemData.espresso = item.topping?.espresso
                    itemData.saucechocolate = item.topping?.saucechocolate
                    itemData.extrafoam = item.topping?.extrafoam
                    itemData.tranchautrang = item.topping?.tranchautrang
                    itemData.type = item.type
                    
                    do {
                        let data = try Data(contentsOf: URL(string: item.imageUrl!)!)
                        itemData.imageData = data
                    } catch {
                        print(error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        self.persister.saveContext {
                            self.persister.fetch(ItemData.self, completion: {(itemData) in
                                completion(itemData)
                            })
                        }
                    }
                })
                if let dataItemVersion = itemRespon.dataVersion {
                    self.`default`.set(dataItemVersion, forKey: "dataItemVersion")
                }
                
            } catch {
                
            }
            
        })
    }
    
    func requestPostDataAndSave(completion: @escaping([PostData]) -> Void) {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        guard let url = EndPoint(rawValue: "post")?.urlPath else { return }
        
        let queue = DispatchQueue(label: "com.TCHClone.api", qos: .background, attributes: .concurrent)
        AF.request(url).response(queue: queue, completionHandler:
        
        {(responData) in
            guard let data = responData.data?.parseData(removeString: "null,") else { return }
            do {
                
                let postReponse = try JSONDecoder().decode(PostResult.self, from: data)
                let posts = postReponse.results
                posts.forEach({(post) in
                    let postData = PostData(context: self.persister.context)
                    postData.title = post.title
                    postData.descriptionPost = post.description
                    postData.link = post.link
                    postData.id = post.id!
                    postData.type = post.type
                    postData.order = post.order ?? false
                    let url = URL(string: post.imageUrl!)
                    do {
                        let data = try Data(contentsOf: url!)
                        postData.image = data
                    } catch {
                        print(error.localizedDescription)
                    }
                })
                DispatchQueue.main.async {
                    self.persister.saveContext {
                        self.persister.fetch(PostData.self, completion: {(postData) in
                            completion(postData)
                        })
                    }
                }
                if let dataPostVersion = postReponse.data_version {
                    self.`default`.set(dataPostVersion, forKey: "versionPostData")
                }
            } catch {
                print(error.localizedDescription)
            }
            
        })
        
    }
    




private func fetchImage(withUrlString urlString: String, completion: @escaping(Data) -> () ){
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url, completionHandler: {(data, respon, error) in
        if let err = error {
            print("Failed to fetch data with err: \(err.localizedDescription)")
            return
        }
        guard let data = data else { return }
        
        completion(data)
    }).resume()
}
var lastimgUrlToLoadDataImage: String?
private func fetchImageData(withUrlString urlString: String) -> Data?{
    var dataImage: Data?
    
    if let cachedDataImage = imageDataCache[urlString] {
        dataImage = cachedDataImage
        return dataImage
    }
    //url for image location
    guard let url = URL(string: urlString) else { return nil }
    
    // fetch contents of url
    URLSession.shared.dataTask(with: url, completionHandler: {(data, respon, error) in
        if let err = error {
            print(err.localizedDescription)
        }
        if self.lastimgUrlToLoadDataImage != url.absoluteString {
            return
        }
        //image data
        guard let imageData = data else { return }
        
        //set key value for image cache
        imageDataCache[urlString] = imageData
        
        //set image
        DispatchQueue.main.async {
            dataImage = imageData
        }
    }).resume()
    
    return dataImage
}
}


