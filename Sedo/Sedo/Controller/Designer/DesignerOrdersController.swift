//
//  DesignerOrdersController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/18.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class DesignerOrdersController: UITableViewController, IndicatorInfoProvider {

    let orderCellId = "orderCell"
    var itemInfo = IndicatorInfo(title: "orders")
    var orders: [Order] = []

    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        fetchDesignerOrder()

    }

    // MARK: - Set Up

    func setupTableView() {

        tableView.register(
            UINib(nibName: "DesignerRequestCell", bundle: Bundle.main),
            forCellReuseIdentifier: orderCellId
        )

        tableView.allowsSelection = false

        tableView.separatorStyle = .none

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-walkman"))
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
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: orderCellId, for: indexPath) as? DesignerRequestCell else { return DesignerRequestCell() }
        let order = orders[indexPath.row]
        cell.serviceLabel.text = order.service
        cell.dateLabel.text = order.date
        cell.timeLabel.text = order.customer.name
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Fetch data

    func fetchDesignerOrder() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail to fetch user uid in customer orders page")
            return
        }
        // use user id as node key //
        let ref = Database.database().reference().child("order-designer").child(uid)
        ref.observe(.value, with: { (snapshot) in

            self.orders = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                print(child.key)
                print(child.value)
                let id = child.key
                guard
                    let dictionary = child.value as? [String: String],
                    let service = dictionary["service"],
                    let date = dictionary["date"],
                    let customerId = dictionary["customerId"]
                    else {
                        print("fail to transform type to dictionary")
                        return
                }

                let userRef = Database.database().reference().child("user")
                userRef.observe(.value, with: { (userSnapshot) in
                    guard
                        let userDict = userSnapshot.value as? [String: AnyObject],
                        let customerInfo = userDict[customerId] as? [String: AnyObject],
                        let customerName = customerInfo["name"] as? String,
                        let designerInfo = userDict[uid] as? [String: AnyObject],
                        let designerName = designerInfo["name"] as? String
                        else {
                            print("fail to get users' info")
                            return
                    }

                    let customer = Customer(name: customerName, id: customerId)
                    let designer = Designer(name: designerName, id: uid)

                    self.orders.append(Order(service: service, id: id, customer: customer, designer: designer, date: date))

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
