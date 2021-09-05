//
//  AppDelegate.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import UIKit
import Firebase
import RealmSwift
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(
            
            schemaVersion: 1,

            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    
                }
            })

        Realm.Configuration.defaultConfiguration = config
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
          schemaVersion: 2,
          migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 2) {
            }
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

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

