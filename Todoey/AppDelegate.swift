//
//  AppDelegate.swift
//  Todoey
//
//  Created by Khaled Aldousari  on 8/2/18.
//  Copyright © 2018 Khaled Aldousari . All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // this gets called before viewDidLoad
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
            _ = try Realm()
     
        } catch {
            
            print("Error insantiating new realm, \(error)")
        }
        return true
    }
    

    
    
}

