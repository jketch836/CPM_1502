//
//  AppDelegate.swift
//  ParseProject_iOS
//
//  Created by Josh Ketcham on 2/8/15.
//  Copyright (c) 2015 Full Sail. All rights reserved.
//

import UIKit

let kReachableWIFI = "ReachableWithWIFI"
let kNotReachable = "NotReachable"
let kReachableWWAN = "ReachableWithWWAN"

var reachability: Reachability?
var currentInternetStatus = kReachableWIFI

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var internetStatus: Reachability?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatus:", name: kReachabilityChangedNotification, object: nil)
        
        internetStatus = Reachability.reachabilityForInternetConnection()
        internetStatus?.startNotifier()
        if internetStatus != nil {
            
            self.statusChangedWithReachability(internetStatus!)
            
        }
        
        
        Parse.setApplicationId("kia8hxKPAggdGJMs83Whoa7MSfs32o4fYVKVJVVO", clientKey: "K9Sl41y8WQGTQtufKIbfYjZVv2LfVqC5Wa7xxPZN")
        
        //        let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
        //        let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
        //        application.registerUserNotificationSettings(settings)
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
        
    }
    
    func reachabilityStatus(notifiy: NSNotification) {
        
        reachability = notifiy.object as? Reachability
        self.statusChangedWithReachability(reachability!)
        
    }
    
    func statusChangedWithReachability(reachabilityStatus: Reachability) {
        
        var theNetworkStatus: NetworkStatus = reachabilityStatus.currentReachabilityStatus()
        
        if theNetworkStatus.value == NotReachable.value {
            
            println("Not Connected")
            currentInternetStatus = kNotReachable
            
            
        } else if theNetworkStatus.value == ReachableViaWiFi.value {
            
            println("Wi-Fi Connected")
            currentInternetStatus = kReachableWIFI
            
            
        } else if theNetworkStatus.value == ReachableViaWWAN.value {
            
            println("WWAN Connected")
            currentInternetStatus = kReachableWWAN

        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("internetStatus", object: nil)
        
    }
    
}

