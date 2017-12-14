//
//  ViewController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func designerMode(_ sender: Any) {
        let designerController = DesignerTabBarController(itemTypes: [.calendar, .portfolio, .service, .profile])
        self.present(designerController, animated: true, completion: nil)
    }
    
    @IBAction func customerMode(_ sender: Any) {
        let customerController = CustomerTabBarController(itemTypes: [.main, .order, .profile])
        self.present(customerController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        


        // try send request //
        let request = Request()
        let customer = Customer()
        let designer = Designer()
        RequestManager.sendRequest(send: request, from: customer, to: designer)
        // try send request //

        // try fetch request //
//        let designer = Designer()
        RequestManager.fetchRequest(receipient: designer)
        // try fetch request //
    }

}
