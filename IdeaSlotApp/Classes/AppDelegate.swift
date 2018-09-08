//
//  AppDelegate.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var centerContainer: MMDrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Realm Migration
        let config = Realm.Configuration(
            schemaVersion: 12,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 12) {}
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        //Set Up Category
        RealmInitializer.setUp()
        
        //Set Up DropDown
        DropDown.startListeningToKeyboard()
        
        //Set Up DrawerMenu
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ParentWordsView") as! ParentWordsListViewController
        
        let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "PagingMenuVC01") as! PageViewController01
        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav,rightDrawerViewController:nil)
        
        //オープン方法のモード指定
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.all
        
        //クローズ方法のモード指定
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
        
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

