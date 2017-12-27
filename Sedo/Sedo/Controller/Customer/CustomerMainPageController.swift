//
//  CustomerMainPageController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class CustomerMainPageController: UITableViewController {

    let mainCellId = "mainCell"
    var users: [User] = []
    var currentMe: Customer?
    var portfolios: [String: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableViewBackground()

        setupNavigationBar()

        // MARK: - Fetch Current User Infomation

        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user").child(uid)
        ref.observe(.value) { (snapshot) in
            guard
                let currentUser = snapshot.value as? [String: AnyObject],
                let name = currentUser["name"] as? String
            else { return }
            self.currentMe = Customer(name: name, id: uid)
        }

        fetchUsers()

    }

    // MARK: - Set Up

    func setupTableViewBackground() {

        tableView.register(UINib(nibName: "MainPageCell", bundle: Bundle.main), forCellReuseIdentifier: mainCellId)

        tableView.separatorStyle = .none

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-woman"))
        backgroundImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImageView

    }

    func setupNavigationBar() {
//        self.navigationController?.navigationBar.backgroundColor = .black
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.title = "Main Page"

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]

    }

    // MARK: - Fetch Data

    func fetchUsers() {

        let ref = Database.database().reference()

        let userRef = ref.child("user")

        userRef.observe(.value) { (snapshot) in

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

                let portfolioRef = ref.child("portfolio").child(id)

                portfolioRef.observe(.value, with: { (portfolioShot) in
                    var imageUrls: [String] = []
                    for child in portfolioShot.children {
                        guard let child = child as? DataSnapshot else { return }

                        let portfolioId = child.key

                        guard
                            let portfolioDict = child.value as? [String: String],
                            let imageUrl = portfolioDict["imageUrl"]
                        else {
                            print("fail to get portfolio detail in main page!")
                            return
                        }

                        imageUrls.append(imageUrl)

                    }

                    self.portfolios.updateValue(imageUrls, forKey: id)

                    self.tableView.reloadData()

                })

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

        let user = users[indexPath.row]

        if let imageUrls = portfolios[user.id], let url = imageUrls.last {
                
                if let imageURL = URL(string: url) {

                    cell.mainPageImageView.image = nil

                    Nuke.loadImage(with: imageURL, into: cell.mainPageImageView)

                }

        } else {

            print("\(user.username) has no portfolio!")

        }

        cell.designerNameLabel.text = user.username

        cell.bookingButton.addTarget(self, action: #selector(handleBooking), for: .touchUpInside)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let portfolioController = PortfolioController(collectionViewLayout: UICollectionViewFlowLayout())
        let designer = Designer(name: user.username, id: user.id)
        portfolioController.author = designer
        portfolioController.currentMe = self.currentMe
        self.navigationController?.pushViewController(portfolioController, animated: true)
    }

    @objc func handleBooking(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview?.superview as? MainPageCell,
            let indexPath = tableView.indexPath(for: cell)
        else {
            print("fail to find out selected designer to book service")
            return
        }

        guard let me = self.currentMe else {
            print("fail to fetch current user")
            return
        }

        let user = users[indexPath.row]
        let requestController = BookingController()
        requestController.designer = Designer(name: user.username, id: user.id)
        requestController.customer = me
        self.navigationController?.pushViewController(requestController, animated: true)
    }

}
