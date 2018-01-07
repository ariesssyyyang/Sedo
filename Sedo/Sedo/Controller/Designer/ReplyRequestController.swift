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

        let leftString = NSLocalizedString("Accept", comment: "reply page accept button")
        replyView.leftButton.setTitle(leftString, for: .normal)
        replyView.leftButton.addTarget(self, action: #selector(handleYes(_:)), for: .touchUpInside)

        let rightString = NSLocalizedString("Reject", comment: "reply page reject button")
        replyView.rightButton.setTitle(rightString, for: .normal)
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

        let titleString = NSLocalizedString("Reply", comment: "reply page nav bar")
        self.navigationItem.title = titleString

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

        let localTitle = NSLocalizedString("Success", comment: "alert")
        let title = AlertManager.successTitle(title: localTitle)
        alert.setValue(title, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Request become an order. Check it out!", comment: "alert")
        let message = AlertManager.customizedMessage(message: localMessage)
        alert.setValue(message, forKey: "attributedMessage")

        let okString = NSLocalizedString("OK", comment: "alert action")
        let ok = UIAlertAction(title: okString, style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)

        present(alert, animated: true, completion: nil)

    }

    func deleteRequestAlert() {

        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let localTitle = NSLocalizedString("Notice", comment: "alert")
        let title = AlertManager.customizedTitle(title: localTitle)
        alert.setValue(title, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Request is gonna deleted, do you want to continue?", comment: "alert")
        let message = AlertManager.customizedMessage(message: localMessage)
        alert.setValue(message, forKey: "attributedMessage")

        let yesString = NSLocalizedString("Yes", comment: "alert action")
        let yes = UIAlertAction(title: yesString, style: .default) { (_) in
            guard let request = self.request else { return }
            RequestManager.rejectRequest(for: request)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(yes)

        let cancelString = NSLocalizedString("Cancel", comment: "alert action")
        let cancel = UIAlertAction(title: cancelString, style: .destructive, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

}
