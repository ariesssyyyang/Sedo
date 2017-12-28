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

        setupTableView()

        fetchDesignerPendingOrder()

    }

    // MARK: - Set Up

    func setupTableView() {

        tableView.register(
            UINib(nibName: "DesignerRequestCell", bundle: Bundle.main),
            forCellReuseIdentifier: requestCellId
        )

        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)

        tableView.separatorStyle = .none
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: requestCellId, for: indexPath) as? DesignerRequestCell else { return DesignerRequestCell() }

        let request = requests[indexPath.row]
        let time = createdTime(request.createdDate)

        cell.serviceLabel.text = request.service
        cell.dateLabel.text = request.date
        cell.timeLabel.text = time

        return cell
    }

    // MARK: - Fetch data

    func fetchDesignerPendingOrder() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail to fetch user uid in pending order page!")
            return
        }

        let ref = Database.database().reference().child("request-designer").child(uid)
        ref.observe(.value, with: { (snapshot) in

            self.requests = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                print(child.key)
                print(child.value)
                let id = child.key
                guard
                    let dictionary = child.value as? [String: String],
                    let customerId = dictionary["customerId"],
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

                    self.requests.append(Request(service: service, id: id, customer: customer, designer: designer, createdDate: createdDate, date: date))

                    self.tableView.reloadData()
                })

            }

            self.tableView.reloadData()

        }, withCancel: nil)
    }

    func createdTime(_ dateString: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let createdDate = dateFormatter.date(from: dateString)
        else {
            print("fail to transform createdDate: String -> Date")
            return "N/A"
        }

        let StringFormatter = DateFormatter()
        StringFormatter.dateFormat = "h:mm a"

        let timeString = StringFormatter.string(from: createdDate)
        return timeString

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let replyController = ReplyRequestController()
        replyController.request = self.requests[indexPath.row]
        self.navigationController?.pushViewController(replyController, animated: true)
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

/*
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
