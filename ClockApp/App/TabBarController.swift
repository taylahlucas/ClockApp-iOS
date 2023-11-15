//
//  TabBarController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        let showAlarmsViewController = ShowAlarmsViewController()
        showAlarmsViewController.tabBarItem = UITabBarItem(title: "Alarms", image: .none, tag: 0)
        
        let stopwatchViewController = StopwatchViewController()
        stopwatchViewController.tabBarItem = UITabBarItem(title: "Stopwatch", image: .none, tag: 1)
        
        let tabBarList = [showAlarmsViewController, stopwatchViewController]
        
        viewControllers = tabBarList
    }
}
