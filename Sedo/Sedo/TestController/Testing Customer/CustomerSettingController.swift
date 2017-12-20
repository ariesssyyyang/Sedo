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
        btn.backgroundColor = UIColor.darkGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        return btn
    }()

    @objc func changeMode() {
        let designerController = DesignerTabBarController(itemTypes: [.calendar, .portfolio, .service, .profile])
        self.present(designerController, animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Customer"

        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(changeModeButton)
        
        changeModeButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeModeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        changeModeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

}
