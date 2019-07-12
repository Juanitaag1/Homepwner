//
//  AppDelegate.swift
//  Homepwner
//
//  Created by juanita aguilar on 4/27/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        //create ItemStore
        let itemStore = ItemStore()
        
        //Access ItemsViewController and set its itemStore
        //When embedded the ItemsVC in the UINavigationController, Ch14 Pg243, made the UINC the rootview
        //instead of ItemsVC & it broke app, so need to change that here to make new contract to make app work again
        //let itemsController = window!.rootViewController as! ItemsViewController
        //pg 244 now add the next 2 lines to update the rootview controller and
        //make the ItemsVC the UINavigationController's topViewC
        //UINAvigationController has a back button and sets the ItemsVC to the start of the app
        let navController =  window!.rootViewController as! UINavigationController
        let itemsController = navController.topViewController as! ItemsViewController
        
        itemsController.itemStore = itemStore //no go to the ItemsStore.swift and implement
        //the designatoed initializer to add 5 random objects
        //init(){for _in
        
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

