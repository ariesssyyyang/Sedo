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

    let changeModeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("go customer mode", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true

        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        return btn
    }()

    let viewOrderButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("view order", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true

        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(viewOrders), for: .touchUpInside)
        return btn
    }()

    @objc func changeMode() {

        self.dismiss(animated: true, completion: nil)

    }

    @objc func viewOrders() {
        let designerOrderListController = DesignerOrderListController()
        self.navigationController?.pushViewController(designerOrderListController, animated: true)
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

        self.view.addSubview(viewOrderButton)
        viewOrderButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewOrderButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        viewOrderButton.centerYAnchor.constraint(equalTo: changeModeButton.bottomAnchor, constant: 50).isActive = true
        viewOrderButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func setupNavigationBar() {
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
//        self.navigationController?.navigationBar.tintColor = UIColor(
//            red: 53.0 / 255.0,
//            green: 184.0 / 255.0,
//            blue: 208 / 255.0,
//            alpha: 1.0
//        )
        self.navigationItem.title = "Designer Mode"
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.white]

    }

}
