//
//  PersistenceService.swift
//  TCHClone
//
//  Created by Trần Huy on 6/2/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import CoreData
class PersistenceService {
    private init() {}
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TCHClone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support

    func saveContext (completion: @escaping() ->Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion()
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func deleteContext (completon: @escaping() -> Void) {
        let context = persistentContainer.viewContext
        do {
            
        }
    }
//    func prepare(dataForSaving: [Post]) {
//        
//        
//        _ = dataForSaving.map{self.createEntityFrom(post: $0)}
//        
//        self.saveContext()
//    }
//    
//    private func createEntityFrom(post: Post) -> PostData? {
//        //Check for all of value
//        guard
//            let title = post.title as? String,
//            let id = post.id as? Int16,
//            let link = post.link as? String,
//            let description = post.description as? String,
//            let imageUrl = post.imageUrl as? String,
//            let type = post.type as? String
//            else { return nil }
//        //Convert
//        let postData = PostData(context: self.context)
//            
//            postData.descriptionPost = description
//            postData.id = id
//            postData.title = title
//            postData.link = link
//        
//            self.fetchImageData(withUrlString: imageUrl, completion: {(data) in
//                
//                let data = data
//                postData.image = data
//                
//            })
//            postData.type = type
//        return postData
//    }
    func fetch<T: NSManagedObject> (_ type: T.Type, completion: @escaping([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            print("fetch comple")
            let object = try context.fetch(request)
            completion(object)
        } catch {
            print(error)
            completion([])
        }
        
    }
    func fetchByPredicate<T: NSManagedObject> (_ type: T.Type, predicate: NSPredicate?, completion: @escaping([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        if (predicate != nil) {
            request.predicate = predicate
        }
        do {
            let listObject = try context.fetch(request)
            completion(listObject)
        } catch {
            completion([])
        }
    }
}

extension PersistenceService {
    private func fetchImageData(withUrlString urlString: String, completion: @escaping(Data) -> () ){
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
    
}
