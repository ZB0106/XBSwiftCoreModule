//
//  AppDelegate.swift
//  XBGitDemo
//
//  Created by xbing on 2020/11/4.
//

import UIKit


public let ScreenBounds = UIScreen.main.bounds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var backIdentifier = UIBackgroundTaskIdentifier.invalid
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: ScreenBounds)
        self.window?.backgroundColor = UIColor.white
    
        let vc = ViewController()
        UINavigationBar.appearance().isTranslucent = false
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        if self.backIdentifier != .invalid {
            application.endBackgroundTask(self.backIdentifier)
            self.backIdentifier = .invalid
        }
        print(#function)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        //app启动时不会调用此方法，app锁屏和按home 都会进入后台运行
        print(#function)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        backIdentifier = application.beginBackgroundTask(expirationHandler: { [unowned self] in
            if self.backIdentifier != .invalid {
                application.endBackgroundTask(self.backIdentifier)
                self.backIdentifier = .invalid
            }
        })
    
        DispatchQueue.global().async { [unowned self] in
            application .endBackgroundTask(self.backIdentifier)
            self.backIdentifier = .invalid
        }
        print(#function)
    }
}

