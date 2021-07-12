//
//  MainTabBarController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 19.05.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let pageViewController = PageViewController()
        let newWeatherViewController = NewWeatherViewController()
        let listViewController = ListViewController()
        let siteViewController = SiteViewController()
        
        delegate = self
        
        tabBar.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let weather = UIImage(systemName: "location.fill", withConfiguration: boldConfig)!
        let list = UIImage(systemName: "list.bullet", withConfiguration: boldConfig)!
        let site = UIImage(systemName: "house", withConfiguration: boldConfig)!
        
        viewControllers = [generateNavigationController(rootViewController: siteViewController, title: "Site", image: site),
                           generateNavigationController(rootViewController: newWeatherViewController, title: "Weather", image: weather),
                           generateNavigationController(rootViewController: listViewController, title: "List", image: list)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.restorationIdentifier == "SiteViewController" {
            if let url = URL(string: "https://www.weather.com"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            return false
        }
        return true
    }
}
