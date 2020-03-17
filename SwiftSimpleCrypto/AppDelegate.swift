//
//  AppDelegate.swift
//  SwiftSimpleCrypto
//
//  Created by ZhaoYong on 2020/3/17.
//  Copyright © 2020 ZhaoYong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    @objc var allowRotation: Bool = false
    @objc static let shared = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.backgroundColor = .white
        
        return true
    }
}

