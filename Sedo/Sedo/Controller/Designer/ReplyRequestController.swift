//
//  ReplyRequestController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class ReplyRequestController: UIViewController {

    let replyView: ReplyRequestView = {
        guard let view = UINib.load(nibName: "ReplyRequestView", bundle: Bundle.main) as? ReplyRequestView else {
            return ReplyRequestView()
        }
        return view
    }()

    var request: Request?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupReplyView()

        setupLabels()

        setupNavigationBar()

        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "back-walkman"))
    }

    // MARK: - Set Up

    func setupReplyView() {

        view.addSubview(replyView)
        replyView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        replyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        replyView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        replyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        replyView.leftButton.addTarget(self, action: #selector(handleYes(_:)), for: .touchUpInside)
        replyView.rightButton.addTarget(self, action: #selector(handleNo(_:)), for: .touchUpInside)
    }

    func setupLabels() {
        replyView.serviceLabel.text = request?.service
        replyView.dateLabel.text = request?.date
        replyView.nameLabel.text = request?.customer.name
        replyView.timeLabel.text = request?.createdDate
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Reply"

    }

    @objc func handleYes(_ sender: UIButton) {
        guard let request = request else { return }
        RequestManager.approveRequest(for: request)
        RequestManager.sendOrder(of: request)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func handleNo(_ sender: UIButton) {

        // Todo: Alert Controller

        guard let request = request else { return }
        RequestManager.rejectRequest(for: request)
        self.navigationController?.popViewController(animated: true)
    }

}
