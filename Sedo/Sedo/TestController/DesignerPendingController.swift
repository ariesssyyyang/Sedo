//
//  DesignerPendingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class DesignerPendingController: UITableViewController {
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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchRequest(of: Designer(name: "May"))
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let replyController = ReplyRequestController()
        replyController.request = self.requests[indexPath.row]
//        self.present(replyController, animated: true, completion: nil)
        self.navigationController?.pushViewController(replyController, animated: true)
    }

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

}
