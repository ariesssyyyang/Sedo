//
//  ServiceController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class ServiceController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    // MARK: - Set up
    
    func setupNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewService))
        self.navigationItem.title = "Service"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]
    }

    @objc func handleNewService() {
        let alertController = UIAlertController(title: "New Service", message: "Please enter service you gonna provide", preferredStyle: .alert)

        alertController.addTextField { (textfield) in
            textfield.placeholder = "new service"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let addNewAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            print(alertController.textFields?.first)
        }
        alertController.addAction(addNewAction)

        self.present(alertController, animated: true, completion: nil)
    }

}
