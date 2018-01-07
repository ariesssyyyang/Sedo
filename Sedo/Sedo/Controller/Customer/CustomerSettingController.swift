//
//  CustomerSettingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Crashlytics

class CustomerSettingController: UIViewController {

    let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(
            red: 133.0/255,
            green: 53.0/255,
            blue: 11.0/255,
            alpha: 1.0
        )
        let logoutString = NSLocalizedString("Log Out", comment: "")
        button.setTitle(logoutString, for: .normal)
        button.titleLabel?.font = UIFont(name: "Kohinoor Bangla", size: 20)
        return button
    }()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavigationBar()

        setupBackground()

        setupButton()

    }

    // MARK: - Set Up

    func setupButton() {

        view.addSubview(logoutButton)

        logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        logoutButton.layer.cornerRadius = 20
        logoutButton.layer.masksToBounds = true

        logoutButton.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
    }

    func setupNavigationBar() {

        let titleString = NSLocalizedString("Setting", comment: "customer setting")
        self.navigationItem.title = titleString

//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-mode2"), style: .plain, target: self, action: #selector(changeMode))

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-exit"), style: .plain, target: self, action: #selector(handleSignOut))

    }

    func setupBackground() {

        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = #imageLiteral(resourceName: "back-woman")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }

    // MARK: - Actions

    @objc func changeMode() {
        let designerController = DesignerTabBarController(itemTypes: [.portfolio, .service, .profile])
        designerController.selectedIndex = 0
        self.present(designerController, animated: true, completion: nil)
    }

    @objc func handleSignOut() {

        let alert = UIAlertController(title: "Log out", message: "Do you really want to logout?", preferredStyle: .alert)

        let localTitle = NSLocalizedString("Logout", comment: "alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20)])

        alert.setValue(titleString, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Do you really want to log out?", comment: "alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alert.setValue(messageString, forKey: "attributedMessage")

        let yesString = NSLocalizedString("Yes", comment: "alert action")
        let okAction = UIAlertAction(title: yesString, style: .default) { (_) in

            UserManager.signOut(viewController: self)
        }

        let cancelString = NSLocalizedString("Cancel", comment: "alert action")
        let cancelAction = UIAlertAction(title: cancelString, style: .destructive, handler: nil)

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
