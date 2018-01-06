//
//  ReplyRequestController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Nuke
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

        setupImageView()

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

    func setupImageView() {

        guard let request = request else {
            print("fail to get request!")
            return
        }
        let ref = Storage.storage().reference().child("designer").child(request.customer.id)
        ref.downloadURL { (url, err) in
            if let error = err {
                print(error)
                return
            }
            if let url = url {
                self.replyView.customerImageView.image = nil
                Nuke.loadImage(with: url, into: self.replyView.customerImageView)
            }
        }
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Reply"

    }

    @objc func handleYes(_ sender: UIButton) {

        doubleCheckAlert(isAccepted: true)

    }

    @objc func handleNo(_ sender: UIButton) {

        doubleCheckAlert(isAccepted: false)

    }

    func doubleCheckAlert(isAccepted: Bool) {

        if isAccepted {

            guard let request = request else { return }
            RequestManager.approveRequest(for: request)
            RequestManager.sendOrder(of: request)

            bookingSuccessAlert()

        } else {

            deleteRequestAlert()

        }
    }

    func bookingSuccessAlert() {

        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let title = AlertManager.successTitle(title: "Success!")
        alert.setValue(title, forKey: "attributedTitle")

        let message = AlertManager.customizedMessage(message: "Request become an order. Check it out!")
        alert.setValue(message, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)

        present(alert, animated: true, completion: nil)

    }

    func deleteRequestAlert() {

        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let title = AlertManager.customizedTitle(title: "Notice!")
        alert.setValue(title, forKey: "attributedTitle")

        let message = AlertManager.customizedMessage(message: "Request is gonna deleted, do you want to continue?")
        alert.setValue(message, forKey: "attributedMessage")

        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            guard let request = self.request else { return }
            RequestManager.rejectRequest(for: request)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(yes)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

}
