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

        fetchPosts()

    }

    // MARK: - Set Up

    func setupTableViewBackground() {

        tableView.register(
            UINib(nibName: "MainPageCell", bundle: Bundle.main),
            forCellReuseIdentifier: mainCellId
        )

        tableView.separatorStyle = .none

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-woman"))
        backgroundImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImageView

        let blackView = UIView()
        blackView.backgroundColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.5
        )

        blackView.frame = backgroundImageView.frame

        backgroundImageView.addSubview(blackView)

    }

    func setupNavigationBar() {

        self.navigationItem.title = "Main Page"

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-mode2"), style: .plain, target: self, action: #selector(changeMode))

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-exit"), style: .plain, target: self, action: #selector(handleSignOut))

    }

    // MARK: - Fetch Data

    func fetchUsers(uid: String) {

        let userRef = Database.database().reference().child("user").child(uid)
        userRef.observeSingleEvent(of: .value) { (userSnapshot) in
            guard
                let userDict = userSnapshot.value as? [String: String],
                let username = userDict["name"]
            else {
                print("fail to fetch users dictionary")
                return
            }

            self.users.append(User(id: uid, username: username))
            self.tableView.reloadData()
        }
    }

    func fetchPosts() {
        let ref = Database.database().reference()

        let portfolioRef = ref.child("portfolio")

        portfolioRef.observe(.value) { (portfolioSnapshot) in
            self.users = []

            for child in portfolioSnapshot.children {

                guard let child = child as? DataSnapshot else {
                    print("can't get portfolio children!")
                    return
                }

                let userId = child.key
                self.fetchUsers(uid: userId)

                var imageUrls: [String] = []

                for post in child.children {
                    guard let post = post as? DataSnapshot else {
                        print("can't get each designer's children")
                        return
                    }

                    let postId = post.key

                    guard
                        let postDict = post.value as? [String: String]
                    else {
                        print("can't get post dictionary")
                        return
                    }

                    guard
                        let description = postDict["description"]
                    else {
                        print("can't get description when fetching portfolio")
                        return
                    }

                    guard
                        let imageUrlString = postDict["imageUrl"]
                    else {
                        print("can't get imageUrl string when fetching portfolio")
                        return
                    }

                    imageUrls.insert(imageUrlString, at: 0)

                }

                self.portfolios.updateValue(imageUrls, forKey: userId)

            }
        }
    }
/*
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
*/
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: mainCellId, for: indexPath) as? MainPageCell else { return MainPageCell() }

        cell.mainScrollView.delegate = self

        var contentWidth: CGFloat = 0.0

        let superImageViewFrame = cell.mainPageImageView.frame

        let user = users[indexPath.row]

        if let imageUrls = portfolios[user.id] {

            if imageUrls.count >= 5 {

                cell.mainPageControl.numberOfPages = 5

                for i in 0...4 {

                    let xCoordinate = superImageViewFrame.width * CGFloat(i)

                    contentWidth += superImageViewFrame.width

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    cell.mainScrollView.addSubview(scrollImageView)

                    scrollImageView.frame = CGRect(x:xCoordinate, y: 0, width: superImageViewFrame.width, height: superImageViewFrame.height)

                    let urlString = imageUrls[i]

                    if let imageURL = URL(string: urlString) {

                        cell.mainPageImageView.image = nil

                        Nuke.loadImage(with: imageURL, into: scrollImageView)

                    }

                }

                cell.mainScrollView.contentSize = CGSize(width: contentWidth, height: superImageViewFrame.height)

            } else if imageUrls.count == 1 {

                cell.mainPageControl.isHidden = true

                let url = imageUrls[0]

                if let imageURL = URL(string: url) {

                    cell.mainPageImageView.image = nil

                    Nuke.loadImage(with: imageURL, into: cell.mainPageImageView)

                }


            } else {

                cell.mainPageControl.numberOfPages = imageUrls.count

                for i in 0...(imageUrls.count - 1) {

                    let xCoordinate = superImageViewFrame.width * CGFloat(i)

                    contentWidth += superImageViewFrame.width

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    cell.mainScrollView.addSubview(scrollImageView)

                    scrollImageView.frame = CGRect(x:xCoordinate, y: 0, width: superImageViewFrame.width, height: superImageViewFrame.height)

                    let urlString = imageUrls[i]

                    if let imageURL = URL(string: urlString) {

                        cell.mainPageImageView.image = nil

                        Nuke.loadImage(with: imageURL, into: scrollImageView)

                    }

                }

                cell.mainScrollView.contentSize = CGSize(width: contentWidth, height: superImageViewFrame.height)

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
        portfolioController.mainPageController = self
        self.navigationController?.pushViewController(portfolioController, animated: true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = scrollView.superview?.superview?.superview as? MainPageCell else {
            print("fail to get scrollView in cell!")
            return
        }
        

    }

    // MARK: - Actions

    @objc func changeMode() {

        let designerController = DesignerTabBarController(itemTypes: [.portfolio, .service, .profile])

        designerController.selectedIndex = 0

        self.present(designerController, animated: true, completion: nil)
    }

    @objc func handleSignOut() {

        let alert = UIAlertController(title: "Log out", message: "Do you really want to logout?", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "Logout" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20)])

        alert.setValue(titleString, forKey: "attributedTitle")

        let messageString = NSMutableAttributedString(string: "Do you really want to log out?" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alert.setValue(messageString, forKey: "attributedMessage")

        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in

            UserManager.signOut()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.view.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        self.present(alert, animated: true, completion: nil)

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
