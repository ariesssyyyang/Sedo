//
//  CustomerPendingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/18.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class CustomerPendingController: UITableViewController, IndicatorInfoProvider {

    let requestCellId = "requestCell"
    var itemInfo = IndicatorInfo(title: "pending")
    var requests: [Request] = []

    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCustomerPendingOrder()

        setupTableViewBackground()
    }

    // MARK: - Set Up

    func setupTableViewBackground() {

        tableView.register(UINib(nibName: "CustomerRequestCell", bundle: Bundle.main), forCellReuseIdentifier: requestCellId)

        tableView.separatorStyle = .none

        tableView.allowsSelection = false

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-woman"))
        backgroundImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImageView

        let blackView = UIView()
        blackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        blackView.frame = backgroundImageView.frame
        backgroundImageView.addSubview(blackView)

    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: requestCellId, for: indexPath) as? CustomerRequestCell else { return CustomerRequestCell() }
        cell.textLabel?.text = "send request: " + requests[indexPath.row].service + " to " + requests[indexPath.row].designer.name
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Fetch data

    func fetchCustomerPendingOrder() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail to fetch user uid in pending order page!")
            return
        }

        let ref = Database.database().reference().child("request-customer").child(uid)
        ref.observe(.value, with: { (snapshot) in

            self.requests = []

            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                let id = child.key
                guard
                    let dictionary = child.value as? [String: String],
                    let designerId = dictionary["designerId"],
                    let service = dictionary["service"],
                    let createdDate = dictionary["createdDate"],
                    let date = dictionary["date"]
                else {
                    print("fail to transform type to dictionary")
                    return
                }

                let userRef = Database.database().reference().child("user")
                userRef.observe(.value, with: { (userSnapshot) in

                    guard
                        let userDict = userSnapshot.value as? [String: AnyObject],
                        let customerInfo = userDict[uid] as? [String: String],
                        let customerName = customerInfo["name"],
                        let designerInfo = userDict[designerId] as? [String: AnyObject],
                        let designerName = designerInfo["name"] as? String
                    else {
                        print("fail to get users' info")
                        return
                    }

                    let customer = Customer(name: customerName, id: uid)
                    let designer = Designer(name: designerName, id: designerId)

                    self.requests.append(Request(service: service, id: id, customer: customer, designer: designer, createdDate: createdDate, date: date))
                    self.tableView.reloadData()
                })

            }

            self.tableView.reloadData()

        }, withCancel: nil)
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
