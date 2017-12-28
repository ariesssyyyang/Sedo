//
//  DesignerNavigationController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/28.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class DesignerNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupNavigationBar() {

        navigationBar.isTranslucent = false

        navigationBar.barTintColor = UIColor.black

        navigationBar.tintColor = UIColor(
            red: 53.0 / 255.0,
            green: 184.0 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        )

        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }

}
