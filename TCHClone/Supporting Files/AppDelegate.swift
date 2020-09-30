//
//  AppDelegate.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var managedObjectContext: NSManagedObjectContext?
    let notificationServices = NotificationServices.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
//        AppDelegate.managedObjectContext = persistentContainer.viewContext
        //Request Notification
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granded, error) in
            
        })
        UNUserNotificationCenter.current().delegate = self
        GMSServices.provideAPIKey(API_KEY)
        GMSPlacesClient.provideAPIKey(API_KEY)
        FirebaseApp.configure()
        Auth.auth().languageCode = "vn";

        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        //Remove this method to stop OneSignal Debugging
//          OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

          //START OneSignal initialization code
          let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
          
          // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
          OneSignal.initWithLaunchOptions(launchOptions,
            appId: APP_ID_ONESIGNAL,
            handleNotificationAction: nil,
            settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        


          // promptForPushNotifications will show the native iOS notification permission prompt.
          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
          OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
          })
          //END OneSignal initializataion code
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        if Auth.auth().canHandle(url) {
            return true
        }
        // URL not auth related, developer should handle it
        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let firebaseAuth = Auth.auth()
        if (firebaseAuth.canHandleNotification(userInfo)) {
            completionHandler(.noData)
            return
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        let id = response.notification.request.identifier
        
        if id == NotificationIdentifier.inCart.stringIdentifier {
            NotificationCenter.default.post(name: Notification.Name("com.incart.tapped"), object: nil)
        } else if UserDefaults.standard.value(forKey: "userID") != nil {
            notificationServices.markReadNoti(with: id, userID: (UserDefaults.standard.value(forKey: "userID") as? String)!)
        }
        

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let id = notification.request.identifier
        var data = notification.request.content.userInfo
        data["isRead"] = false
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd:MM:yyyy HH:mm"
        let dateString = formatter.string(from: date)
        data["date"] = dateString
        if id != NotificationIdentifier.inCart.stringIdentifier {
            notificationServices.receviedNotificationFromServer(with: data, NotiId: id)
        }
        
        print("Received notification with IDjcjkcha = \(id)")

        completionHandler([.sound, .alert])
    }
    
}


    
    



