//
//  CustomerTabBarController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - CustomerTabBarController

import UIKit
import Firebase

class CustomerTabBarController: UITabBarController {

    // MARK: Init

    init(itemTypes: [CustomerTabBarItemType]) {

        super.init(nibName: nil, bundle: nil)

        let viewControllers: [UIViewController] = itemTypes.map(
            CustomerTabBarController.prepare
        )

        setViewControllers(viewControllers, animated: false)

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()

    }

    // MARK: Set Up

    private func setUpTabBar() {

        tabBar.barStyle = .default

        tabBar.isTranslucent = false

        // Todo: palette
        tabBar.tintColor = UIColor(
            red: 53.0 / 255.0,
            green: 184.0 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        )

    }

    // MARK: Prepare Item Type

    static func prepare(for itemType: CustomerTabBarItemType) -> UIViewController {

        switch itemType {

        case .main:

            let navigationController = UINavigationController(rootViewController: CustomerMainPageController())
            navigationController.tabBarItem = CustomerTabBarItem(itemType: itemType)
            return navigationController

        case .order:

            let navigationController = UINavigationController(rootViewController: CustomerOrderListController())
            navigationController.tabBarItem = CustomerTabBarItem(itemType: itemType)
            return navigationController

        case .profile:

            let navigationController = UINavigationController(rootViewController: CustomerSettingController())
            navigationController.tabBarItem = CustomerTabBarItem(itemType: itemType)
            return navigationController
        }

    }
}
