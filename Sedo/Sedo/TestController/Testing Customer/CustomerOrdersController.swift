//
//  CustomerOrdersController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/18.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class CustomerOrdersController: UITableViewController, IndicatorInfoProvider {

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

        tableView.register(UINib(nibName: "CustomerOrderCell", bundle: Bundle.main), forCellReuseIdentifier: orderCellId)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.red

        // To check //
        tableView.allowsSelection = false
        // To check //

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCustomerOrder()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    // MARK: - Fetch data

    func fetchCustomerOrder() {

        // use user id as node key //
        let ref = Database.database().reference().child("order-customer").child("Nick")
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
                    let date = dictionary["date"]
                else {
                    print("fail to transform type to dictionary")
                    return
                }

                self.orders.append(Order(service: service, id: id, date: date))

            }

            self.tableView.reloadData()

        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: orderCellId, for: indexPath) as? CustomerOrderCell else { return CustomerOrderCell() }
        cell.textLabel?.text = orders[indexPath.row].service
        return cell
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
