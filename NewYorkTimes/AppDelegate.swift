//
//  AppDelegate.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.setInitialRootController()
        return true
    }
    
    private func setInitialRootController() {
        let initialVC = mainStoryBoard.instantiateViewController(withIdentifier: "NewsController") as! NewsController
        self.window?.rootViewController = setNavigationController(currentVC: initialVC)
        self.window?.makeKeyAndVisible()
    }
    
    func setNavigationController(currentVC: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: currentVC)
        navVC.navigationBar.tintColor = .white
        navVC.navigationBar.backgroundColor = .black
        navVC.navigationBar.shadowImage = UIImage()
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        navVC.navigationBar.barStyle = .black
        return navVC
    }

}
