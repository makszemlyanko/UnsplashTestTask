//
//  BaseTabBarController.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 21.06.2022.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: FavoriteController(), title: "Favorites", imageName: #imageLiteral(resourceName: "Symbol")),
            createNavController(viewController: SearchController(), title: "Search", imageName: #imageLiteral(resourceName: "search"))
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        navController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = imageName
        return navController
    }
}
