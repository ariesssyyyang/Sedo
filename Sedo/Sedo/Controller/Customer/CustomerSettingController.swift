//
//  CustomerSettingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class CustomerSettingController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavigationBar()

        self.view.backgroundColor = UIColor.white

    }

    func setupNavigationBar() {

        self.navigationItem.title = "Customer Mode"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-mode2"), style: .plain, target: self, action: #selector(changeMode))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-exit"), style: .plain, target: self, action: #selector(handleSignOut))

    }

    // MARK: - Actions

    @objc func changeMode() {
        let designerController = DesignerTabBarController(itemTypes: [.portfolio, .service, .profile])
        designerController.selectedIndex = 2
        self.present(designerController, animated: true, completion: nil)
    }

    @objc func handleSignOut() {
        UserManager.signOut()
    }

}
