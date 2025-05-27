//
//  TabBarController.swift
//  GtSdkDemo-swift
//
//  Created by ak on 2020/03/20.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var homeViewController = HomeViewController()
    var advanceViewController = AdvanceViewController()
    var infoViewController = InfoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAllChildViewController()
    }
    
    func setUpAllChildViewController() {
        setUpOneChildViewController(homeViewController, UIImage(named: "home"), UIImage(named: "home_select"), "首页")
        setUpOneChildViewController(advanceViewController, UIImage(named: "advancedFC"), UIImage(named: "advancedFC_sel"), "高级功能")
        setUpOneChildViewController(infoViewController, UIImage(named: "appInfo"), UIImage(named: "appInfo_sel"), "应用信息")
    }
    
    func setUpOneChildViewController(_ viewController: UIViewController, _ image: UIImage?, _ selectedImage: UIImage?, _ title: String) {
        viewController.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        addChild(NavigationController(rootViewController: viewController))
    }

}
