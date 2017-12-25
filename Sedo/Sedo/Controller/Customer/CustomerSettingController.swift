//
//  CustomerSettingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class CustomerSettingController: UIViewController {

    let changeModeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("go designer mode", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true

        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        return btn
    }()

    let signOutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("sign out", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true

        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return btn
    }()

    @objc func changeMode() {
        let designerController = DesignerTabBarController(itemTypes: [.calendar, .portfolio, .service, .profile])
        self.present(designerController, animated: true, completion: nil)
    }

    @objc func handleSignOut() {
        UserManager.signOut()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        self.view.backgroundColor = UIColor.white
        self.view.addSubview(changeModeButton)

        changeModeButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        changeModeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.view.addSubview(signOutButton)
        signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signOutButton.centerYAnchor.constraint(equalTo: changeModeButton.bottomAnchor, constant: 50).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Customer Mode"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]

    }

}