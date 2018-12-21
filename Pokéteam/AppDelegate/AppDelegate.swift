//
//  AppDelegate.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/18/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.setUpWindow()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.switchToTabBarController),
                                               name: .doneLoadingAllPokemon,
                                               object: nil)
        
        return true
    }
    
    private func setUpWindow()
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if PTPokeAPIDataSource.hasCompletedFullDataLoad() == true
        {
            self.switchToTabBarController()
        }
        else
        {
            let loadingVC = PTLoadDataViewController()
            
            self.window?.rootViewController = loadingVC
            self.window?.makeKeyAndVisible()
        }
    }

    @objc private func switchToTabBarController()
    {
        DispatchQueue.main.async
        {
            let tabBarController = UITabBarController()
            
            for viewController in [PTListAllTrainersViewController(), PTListAllPokemonViewController()]
            {
                let navController = UINavigationController(rootViewController: viewController)
                navController.navigationBar.isTranslucent = false
                
                viewController.tabBarItem = UITabBarItem(title: viewController.title, image: nil, selectedImage: nil)
                tabBarController.addChildViewController(navController)
            }
            
            self.window?.rootViewController = tabBarController
            self.window?.makeKeyAndVisible()
        }
    }
}

