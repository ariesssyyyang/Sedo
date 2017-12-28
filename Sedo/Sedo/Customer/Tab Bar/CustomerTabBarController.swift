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

        tabBar.isTranslucent = true

        // Todo: palette
        tabBar.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        tabBar.unselectedItemTintColor = UIColor(
            red: 133.0/255,
            green: 53.0/255,
            blue: 11.0/255,
            alpha: 1.0
        )

    }

    // MARK: Prepare Item Type

    static func prepare(for itemType: CustomerTabBarItemType) -> UIViewController {

        switch itemType {

        case .main:

            let navigationController = CustomerNavigationController(rootViewController: CustomerMainPageController())
            navigationController.tabBarItem = CustomerTabBarItem(itemType: itemType)
            return navigationController

        case .order:

            let navigationController = CustomerNavigationController(rootViewController: CustomerOrderListController())
            navigationController.tabBarItem = CustomerTabBarItem(itemType: itemType)
            return navigationController

        case .profile:

            let navigationController = CustomerNavigationController(rootViewController: CustomerSettingController())
            navigationController.tabBarItem = CustomerTabBarItem(itemType: itemType)
            return navigationController
        }

    }
}
