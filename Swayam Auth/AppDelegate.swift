//
//  AppDelegate.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let SharedAppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var customNavigationController = UINavigationController()
    var initialViewController = UIViewController();

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        if CurrentUser.isLogin() {
            CurrentUser.sharedInstance.SetAndGetValue(data: CurrentUser.sharedInstance.session ?? [:], isEdit: false)
        }

        initialViewController = Util.getStoryboard().instantiateViewController(withIdentifier: "Login") as! Login

        self.customNavigationController = UINavigationController(rootViewController: self.initialViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.customNavigationController;
        self.window?.makeKeyAndVisible()
        self.customNavigationController.setNavigationBarHidden(true, animated: true);

        // configure custom alert
        Alert.shared.customeAlertConfigure()

        // configure sidemenu
        SideMenu.configureSideMenu()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

