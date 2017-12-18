//
//  DesignerPendingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class DesignerPendingController: UITableViewController, IndicatorInfoProvider {

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
        
        tableView.register(UINib(nibName: "DesignerRequestCell", bundle: Bundle.main), forCellReuseIdentifier: requestCellId)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.orange
        
        // To check //
//        tableView.allowsSelection = false
        // To check //
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDesignerPendingOrder()
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    // MARK: - Fetch data
    
    func fetchDesignerPendingOrder() {
        
        // use user id as node key //
        let ref = Database.database().reference().child("request-designer").child("May")
        ref.observe(.value, with: { (snapshot) in
            
            self.requests = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                print(child.key)
                print(child.value)
                let id = child.key
                guard
                    let dictionary = child.value as? [String: String],
                    let customer = dictionary["customer"],
                    let service = dictionary["service"],
                    let createdDate = dictionary["createdDate"],
                    let date = dictionary["date"]
                    else {
                        print("fail to transform type to dictionary")
                        return
                }
                
                self.requests.append(Request(service: service, id: id, customer: Customer(name: customer), designer: Designer(name: "May"), createdDate: createdDate, date: date))

            }

            self.tableView.reloadData()

        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: requestCellId, for: indexPath) as? DesignerRequestCell else { return DesignerRequestCell() }
        cell.textLabel?.text = "request " + requests[indexPath.row].service + " by " + requests[indexPath.row].customer.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let replyController = ReplyRequestController()
        replyController.request = self.requests[indexPath.row]
//        self.present(replyController, animated: true, completion: nil)
        self.navigationController?.pushViewController(replyController, animated: true)
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

/*
    // Mark: value

    func fetchRequest(of designer: Designer) {

        let ref = Database.database().reference().child("request-designer").child(designer.name)
        ref.observe(.value, with: { (snapshot) in
            self.requests = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                print(child.key)
                print(child.value)
                let id = child.key
                guard
                    let dictionary = child.value as? [String: String],
                    let customer = dictionary["customer"],
                    let service = dictionary["service"],
                    let createdDate = dictionary["createdDate"],
                    let date = dictionary["date"]
                else {
                    print("fail to transform type to dictionary")
                    return
                }

                self.requests.append(Request(service: service, id: id, customer: Customer(name: customer), designer: designer, createdDate: createdDate, date: date))

            }

            self.tableView.reloadData()

        }, withCancel: nil)

    }
*/
}
