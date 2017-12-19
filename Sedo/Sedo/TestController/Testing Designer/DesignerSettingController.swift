//
//  DesignerSettingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class DesignerSettingController: UIViewController {

    let changeModeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.darkGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        return btn
    }()

    let viewOrderButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.brown
        btn.setTitle("view orders", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(viewOrders), for: .touchUpInside)
        return btn
    }()

    @objc func changeMode() {
        let customerController = CustomerTabBarController(itemTypes: [.main, .order, .profile])
        customerController.selectedIndex = 1
        self.present(customerController, animated: true, completion: nil)

    }

    @objc func viewOrders() {
        let designerOrderListController = DesignerOrderListController()
        self.navigationController?.pushViewController(designerOrderListController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Designer"

        self.view.backgroundColor = UIColor.lightGray

        self.view.addSubview(changeModeButton)
        changeModeButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        changeModeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.view.addSubview(viewOrderButton)
        viewOrderButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewOrderButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        viewOrderButton.centerYAnchor.constraint(equalTo: changeModeButton.bottomAnchor, constant: 50).isActive = true
        viewOrderButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

}
