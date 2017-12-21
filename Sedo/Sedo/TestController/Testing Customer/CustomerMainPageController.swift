//
//  CustomerMainPageController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class CustomerMainPageController: UITableViewController {

    let mainCellId = "mainCell"
    var users: [User] = []
    var me: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        // MARK: - Fetch User Infomation
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user").child(uid)
        ref.observe(.value) { (snapshot) in
            guard
                let currentUser = snapshot.value as? [String: AnyObject],
                let name = currentUser["name"] as? String
            else { return }
            self.me = User(id: uid, username: name)
        }

        tableView.register(UINib(nibName: "MainPageCell", bundle: Bundle.main), forCellReuseIdentifier: mainCellId)

        fetchUsers()
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Main Page"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]

    }

    func fetchUsers() {
        let ref = Database.database().reference().child("user")
        ref.observe(.value) { (snapshot) in
            self.users = []
            for child in snapshot.children {
                guard
                    let child = child as? DataSnapshot else { return }
                let id = child.key
                guard
                    let dictionary = child.value as? [String: AnyObject],
                    let username = dictionary["name"] as? String
                else {
                    print("fail to transform type to dictionary")
                    return
                }

                self.users.append(User(id: id, username: username))
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: mainCellId, for: indexPath) as? MainPageCell else { return MainPageCell() }
        cell.designerNameLabel.text = users[indexPath.row].username
        cell.bookingButton.addTarget(self, action: #selector(handleBooking), for: .touchUpInside)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
/*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let requestController = CustomerRequestController()
        requestController.designer = Designer(name: user)
        self.navigationController?.pushViewController(requestController, animated: true)
    }
*/
    @objc func handleBooking(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview?.superview as? MainPageCell,
            let indexPath = tableView.indexPath(for: cell)
        else {
            print("fail to find out selected designer to book service")
            return
        }

        guard let me = self.me else {
            print("fail to fetch current user")
            return
        }

        let user = users[indexPath.row]
        let requestController = CustomerRequestController()
        requestController.designer = Designer(name: user.username, id: user.id)
        requestController.customer = Customer(name: me.username, id: me.id)
        self.navigationController?.pushViewController(requestController, animated: true)
    }

}
