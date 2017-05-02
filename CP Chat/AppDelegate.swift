//
//  AppDelegate.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let isUserSignIn = UserDefaults.standard.bool(forKey: "isUserSignIn")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = UIViewController()
        if(!isUserSignIn){
            viewController = storyBoard.instantiateViewController(withIdentifier: "signIn")
        }else{
            viewController = storyBoard.instantiateViewController(withIdentifier: "mainMenu")
        }
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController?.present(viewController, animated: false, completion: nil)
        return true
    }
}

