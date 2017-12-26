//
//  ServiceController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class ServiceController: UITableViewController {

    var services: [Service] = []
    let serviceCellId = "serviceCell"
    var designer: Designer?

    override func viewDidLoad() {
        super.viewDidLoad()

        if designer == nil {
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            fetchService(uid: myUid)
        } else {
            guard let uid = designer?.id else {
                print("fail to get user id before fetching service!")
                return
            }
            fetchService(uid: uid)
        }

        setupNavigationBar()

        tableView.register(UINib(nibName: "ServiceCell", bundle: Bundle.main), forCellReuseIdentifier: serviceCellId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let currentUserId = Auth.auth().currentUser?.uid, let designerId = designer?.id else { return }

        if currentUserId != designerId {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    // MARK: - Set Up

    func setupNavigationBar() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewService))
        self.navigationItem.title = "Service"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]
    }

    // MARK: - Actions

    @objc func handleNewService() {

        let alertController = UIAlertController(title: "New Service", message: "Please enter detail you gonna provide", preferredStyle: .alert)

        alertController.addTextField { (textfield) in
            textfield.placeholder = "new service"
        }

        alertController.addTextField { (textfield) in
            textfield.placeholder = "price"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let addNewAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard
                let service = alertController.textFields?.first?.text,
                let priceString = alertController.textFields?.last?.text,
                let price = Int(priceString)
            else {
                print("fail to add new service!")
                return
            }

            ServiceManager.addNew(service: service, price: price)

        }
        alertController.addAction(addNewAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Fetch Data

    func fetchService(uid: String) {

        let ref = Database.database().reference().child("service").child(uid)
        ref.observe(.value) { (snapshot) in

            self.services = []

            for child in snapshot.children {

                guard let child = child as? DataSnapshot else { return }

                let service = child.key

                guard
                    let serviceDict = child.value as? [String: AnyObject],
                    let price = serviceDict["price"] as? Int
                else {
                    print("fail to fetch service detail!")
                    return
                }

                self.services.append(Service(service: service, price: price))

            }

            self.tableView.reloadData()

        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: serviceCellId, for: indexPath) as? ServiceCell else { return ServiceCell() }

        let service = services[indexPath.row]

        cell.serviceItemLabel.text = service.service
        cell.priceLabel.text = "NT$ \(service.price)"

        return cell
    }

}
