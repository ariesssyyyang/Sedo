//
//  DesignerReplyController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class DesignerReplyController: UITableViewController {
/*
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.black
        lb.textColor = UIColor.white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
*/

    let requestCellId = "requestCellId"

    var requests: [Request] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellow
/*
        view.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
*/
        let nib = UINib(nibName: "DesignerRequestCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: requestCellId)

        fetchRequest(receipient: Designer(name: "May"))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return requests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(
            withIdentifier: requestCellId,
            for: indexPath
            ) as! DesignerRequestCell
        // swiftlint:enable force_cast

        cell.textLabel?.text = requests[indexPath.row].service

        return cell
    }

    func fetchRequest(receipient: Designer) {

        let ref = Database.database().reference().child("request").child(receipient.name)
        ref.observe(.childAdded, with: { (snapshot) in

            guard
                let dictionary = snapshot.value as? [String: AnyObject],
                let customer = dictionary["customer"] as? String,
                let date = dictionary["date"] as? String,
                let service = dictionary["service"] as? String,
                let status = dictionary["check"] as? Bool
                else {
                    print("fail to transform type to dictionary")
                    return
            }

            self.requests.append(Request(service: service))
            self.tableView.reloadData()

            print("got a new request from \(customer):\nservice:\(service)\ndate:\(date)\ncheck it:\(status)\n")

        }, withCancel: nil)

    }

}
