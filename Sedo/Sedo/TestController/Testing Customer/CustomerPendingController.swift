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

        tableView.register(UINib(nibName: "CustomerRequestCell", bundle: Bundle.main), forCellReuseIdentifier: requestCellId)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.orange

        // To check //
        tableView.allowsSelection = false
        // To check //

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCustomerPendingOrder()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    // MARK: - Fetch data

    func fetchCustomerPendingOrder() {

        // use user id as node key //
        let ref = Database.database().reference().child("request-customer").child("Nick")
        ref.observe(.value, with: { (snapshot) in

            self.requests = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                print(child.key)
                print(child.value)
                let id = child.key
                guard
                    let dictionary = child.value as? [String: String],
                    let designer = dictionary["designer"],
                    let service = dictionary["service"],
                    let createdDate = dictionary["createdDate"],
                    let date = dictionary["date"]
                else {
                    print("fail to transform type to dictionary")
                    return
                }

                self.requests.append(Request(service: service, id: id, customer: Customer(name: "Nick"), designer: Designer(name: designer), createdDate: createdDate, date: date))

            }

            self.tableView.reloadData()

        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: requestCellId, for: indexPath) as? CustomerRequestCell else { return CustomerRequestCell() }
        cell.textLabel?.text = requests[indexPath.row].service + " by " + requests[indexPath.row].designer.name
        return cell
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
