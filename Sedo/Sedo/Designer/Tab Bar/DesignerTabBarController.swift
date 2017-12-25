//
//  DesignerTabBarController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - DesignerTabBarController

import UIKit

class DesignerTabBarController: UITabBarController {

    // MARK: Init

    init(itemTypes: [DesignerTabBarItemType]) {

        super.init(nibName: nil, bundle: nil)

        let viewControllers: [UIViewController] = itemTypes.map(
            DesignerTabBarController.prepare
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

    static func prepare(for itemType: DesignerTabBarItemType) -> UIViewController {

        switch itemType {

        case .calendar:

            //            let navigationController = GradientNavigationController(
            //                rootViewController: productGridViewController
            //            )
            //
            //            navigationController.tabBarItem = TabBarItem(
            //                itemType: itemType
            //            )
            //
            //            return navigationController
//            let navigationController = UINavigationController(rootViewController: DesignerPendingController())
//            navigationController.tabBarItem = DesignerTabBarItem(itemType: itemType)
            let navigationController = UINavigationController(rootViewController: DesignerSettingController())
            navigationController.tabBarItem = DesignerTabBarItem(itemType: itemType)
            return navigationController

        case .portfolio:

            //            let profileTableViewController = ProfileTableViewController(style: .plain)
            //
            //            let navigationController = GradientNavigationController(
            //                rootViewController: profileTableViewController
            //            )
            //
            //            navigationController.tabBarItem = TabBarItem(
            //                itemType: itemType
            //            )
            //
            //            return navigationController

            let navigationController = UINavigationController(rootViewController: PortfolioController(collectionViewLayout: UICollectionViewFlowLayout()))
            navigationController.tabBarItem = DesignerTabBarItem(itemType: itemType)
            return navigationController

        case .service:

            //            let storyboard = UIStoryboard(name: "CartStoryboard", bundle: nil)
            //            let cartTableViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController")
            //
            //            let navigationController = GradientNavigationController(
            //                rootViewController: cartTableViewController
            //            )
            //
            //            navigationController.tabBarItem = TabBarItem(
            //                itemType: itemType
            //            )
            //
            //            return navigationController
            let navigationController = UINavigationController(rootViewController: ServiceController())
            navigationController.tabBarItem = DesignerTabBarItem(itemType: itemType)
            return navigationController

        case .profile:

            let navigationController = UINavigationController(rootViewController: DesignerSettingController())
            navigationController.tabBarItem = DesignerTabBarItem(itemType: itemType)
            return navigationController
        }

    }
}
