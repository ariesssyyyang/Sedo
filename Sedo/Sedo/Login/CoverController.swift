//
//  SigninController.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/1.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class CoverController: UIViewController {

    let logo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()

        setupLogo()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkLogin()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Check Login

    func checkLogin() {

        if Auth.auth().currentUser != nil {

            let customerTabBarController = CustomerTabBarController(itemTypes: [.main, .order, .profile])

            AppDelegate.shared.window?.updateRoot(
                to: customerTabBarController,
                animation: crossDissolve,
                duration: 1.0,
                completion: nil
            )

        } else {

            let loginController = LoginController()

            AppDelegate.shared.window?.updateRoot(
                to: loginController,
                animation: crossDissolve,
                duration: 2.5,
                completion: nil
            )

        }
    }

    // MARK: - Set Up

    func setupBackground() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = #imageLiteral(resourceName: "back-blurcity")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)

        let backView = UIView(frame: backgroundImageView.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        backgroundImageView.addSubview(backView)
    }

    func setupLogo() {
        view.addSubview(logo)
        logo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        logo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 60)
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        logo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        logo.font = UIFont(name: "Copperplate-Light", size: 36)
        logo.text = "s t y l i f e"
        logo.textColor = .white

    }

}
