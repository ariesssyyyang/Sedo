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
    var customer: Customer?

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

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let currentUserId = Auth.auth().currentUser?.uid, let designerId = designer?.id else { return }

        if currentUserId != designerId {
//            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-booking"), style: .plain, target: self, action: #selector(newBooking))
            tableView.backgroundView = nil
        }
    }

    // MARK: - Set Up

    func setupNavigationBar() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewService))
        self.navigationItem.title = "Service"

    }

    func setupTableView() {

        tableView.register(UINib(nibName: "ServiceCell", bundle: Bundle.main), forCellReuseIdentifier: serviceCellId)

        tableView.separatorStyle = .none

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-walkman"))
        backgroundImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImageView

        let blackView = UIView()
        blackView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        blackView.frame = backgroundImageView.frame
        backgroundImageView.addSubview(blackView)

    }

    // MARK: - Actions

    @objc func newBooking() {

        let bookingController = BookingController()

        bookingController.customer = customer
        bookingController.designer = designer

        self.navigationController?.pushViewController(bookingController, animated: true)
    }

    @objc func handleNewService() {

        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "New Service" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20)])

        alertController.setValue(titleString, forKey: "attributedTitle")

        let messageString = NSMutableAttributedString(string: "Please enter service detail you gonna provide." as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alertController.setValue(messageString, forKey: "attributedMessage")

        alertController.addTextField { (textfield) in
            textfield.placeholder = "item"
            textfield.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }

        alertController.addTextField { (textfield) in
            textfield.placeholder = "price"
            textfield.heightAnchor.constraint(equalToConstant: 20).isActive = true
            textfield.keyboardType = .numberPad
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let addNewAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if alertController.textFields?.first?.text == "" || alertController.textFields?.last?.text == "" {
                self.showTextfieldAlert()
            } else {
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
        }
        alertController.addAction(addNewAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func showTextfieldAlert() {
        let textfieldAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "Error" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.red])

        textfieldAlert.setValue(titleString, forKey: "attributedTitle")

        let messageString = NSMutableAttributedString(string: "Please enter all infomations needed." as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        textfieldAlert.setValue(messageString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        textfieldAlert.addAction(ok)

        self.present(textfieldAlert, animated: true, completion: nil)
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

        cell.selectionStyle = .none
        cell.serviceItemLabel.text = service.service
        cell.priceLabel.text = "NT$ \(service.price)"

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let service = services[indexPath.row]

        guard let uid = Auth.auth().currentUser?.uid else { return }

        switch editingStyle {
        case .delete:
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

            let titleString = NSMutableAttributedString(string: "Notice" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.red])

            alert.setValue(titleString, forKey: "attributedTitle")

            let messageString = NSMutableAttributedString(string: "Press sure to delete the service." as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

            alert.setValue(messageString, forKey: "attributedMessage")

            let sureAction = UIAlertAction(title: "Sure", style: .default, handler: { (_) in
                let serviceRef = Database.database().reference().child("service").child(uid).child(service.service)
                serviceRef.removeValue()
            })
            alert.addAction(sureAction)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        default:
            return
        }
    }

}
