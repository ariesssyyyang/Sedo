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

        tableView.register(UINib(nibName: "DesignerOrderCell", bundle: Bundle.main), forCellReuseIdentifier: orderCellId)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.red

        // To check //
        tableView.allowsSelection = false
        // To check //

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDesignerOrder()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: orderCellId, for: indexPath) as? DesignerOrderCell else { return DesignerOrderCell() }
        cell.textLabel?.text = orders[indexPath.row].service
        return cell
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
