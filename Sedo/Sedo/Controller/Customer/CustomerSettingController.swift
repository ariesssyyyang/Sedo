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

        self.navigationItem.title = "Setting"

//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-mode2"), style: .plain, target: self, action: #selector(changeMode))

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-exit"), style: .plain, target: self, action: #selector(handleSignOut))

    }

    // MARK: - Actions

    @objc func changeMode() {
        let designerController = DesignerTabBarController(itemTypes: [.portfolio, .service, .profile])
        designerController.selectedIndex = 0
        self.present(designerController, animated: true, completion: nil)
    }

    @objc func handleSignOut() {

        let alert = UIAlertController(title: "Log out", message: "Do you really want to logout?", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "Logout" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20)])

        alert.setValue(titleString, forKey: "attributedTitle")

        let messageString = NSMutableAttributedString(string: "Do you really want to log out?" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alert.setValue(messageString, forKey: "attributedMessage")

        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in

            UserManager.signOut()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.view.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        self.present(alert, animated: true, completion: nil)

    }

}
