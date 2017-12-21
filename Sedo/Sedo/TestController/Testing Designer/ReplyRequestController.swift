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

    let yesButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("yes", for: .normal)
        btn.addTarget(self, action: #selector(handleYes), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let noButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("no", for: .normal)
        btn.addTarget(self, action: #selector(handleNo), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let requestLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.darkGray
        lb.textColor = UIColor.lightGray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    var request: Request?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        self.view.backgroundColor = UIColor.brown

        self.view.addSubview(yesButton)
        yesButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        yesButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        yesButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        yesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.view.addSubview(noButton)
        noButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        noButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        noButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.view.addSubview(requestLabel)
        requestLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        requestLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        requestLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        requestLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        requestLabel.text = request?.service
    }

    func setupNavigationBar() {
        
        self.navigationItem.title = "Reply"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]
        
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
