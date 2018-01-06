//
//  DesignerSettingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class DesignerSettingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        self.view.backgroundColor = UIColor.white

        let orderbutton = UIButton()
        orderbutton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(orderbutton)
        orderbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orderbutton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        orderbutton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        orderbutton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        orderbutton.setTitle("view order", for: .normal)
        orderbutton.titleLabel?.textColor = .black
        orderbutton.titleLabel?.backgroundColor = .gray
        orderbutton.addTarget(self, action: #selector(viewOrders), for: .touchUpInside)
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Designer Mode"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-mode"), style: .plain, target: self, action: #selector(changeMode))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-exit"), style: .plain, target: self, action: #selector(handleSignOut))

    }

    // MARK: - Actions

    @objc func changeMode() {

        self.dismiss(animated: true, completion: nil)

    }

    @objc func viewOrders() {
        let designerOrderListController = DesignerOrderListController()
        self.navigationController?.pushViewController(designerOrderListController, animated: true)
    }

    @objc func handleSignOut() {
        UserManager.signOut()
    }

}
