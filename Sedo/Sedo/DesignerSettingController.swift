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

    @objc func changeMode() {
        let customerController = CustomerTabBarController(itemTypes: [.main, .order, .profile])
        self.present(customerController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(customerController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(changeModeButton)
        
        changeModeButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        changeModeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }

}
