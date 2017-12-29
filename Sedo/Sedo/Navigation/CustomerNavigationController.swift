//
//  CustomerNavigationController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/28.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class CustomerNavigationController: UINavigationController {

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavigationBar()
    }

    func setupNavigationBar() {

        navigationBar.barTintColor = .white

        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon-back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon-back")

        navigationBar.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]

    }

}
