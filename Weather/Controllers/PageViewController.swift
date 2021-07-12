//
//  PageViewController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 16.06.2021.
//

import UIKit

class PageViewController: UIPageViewController {
    
    fileprivate lazy var pages: [UIViewController] = [UIViewController]()
    var city: [CurrentWeather] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.city = StorageManager.shared.getCities()
        
//        for i in 1...city.count {
//            let vc = NewWeatherViewController()
//
//        }
        
        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    func displayViewController(atIndex index: Int) -> NewWeatherViewController? {
        guard index >= 0 else { return nil }
        guard index < city.count else { return nil }
        guard let newVC = UIViewController() as? NewWeatherViewController else { return nil }
        newVC.index = index
        return newVC
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! NewWeatherViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! NewWeatherViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return city.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = pageViewController.viewControllers?.first else { return 0 }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else { return 0 }
        return firstVCIndex
    }
}
