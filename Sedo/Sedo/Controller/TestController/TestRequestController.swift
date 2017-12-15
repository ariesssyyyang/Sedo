//
//  TestRequestController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class TestRequestController: UIViewController, UITextFieldDelegate {

    let customerTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.backgroundColor = UIColor.lightGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let serviceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "service"
        tf.backgroundColor = UIColor.lightGray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let sendRequestButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("send", for: .normal)
        btn.addTarget(self, action: #selector(requestService), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        customerTextField.delegate = self
        serviceTextField.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.view.backgroundColor = UIColor.darkGray

        self.view.addSubview(customerTextField)
        customerTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        customerTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        customerTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        customerTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.view.addSubview(serviceTextField)
        serviceTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        serviceTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        serviceTextField.topAnchor.constraint(equalTo: customerTextField.bottomAnchor, constant: 20).isActive = true
        serviceTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.view.addSubview(sendRequestButton)
        sendRequestButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        sendRequestButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 100).isActive = true
        sendRequestButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        sendRequestButton.heightAnchor.constraint(equalToConstant: 100).isActive = true

    }

    @objc func requestService() {
        guard
            let customerName = customerTextField.text,
            let service = serviceTextField.text
        else { return }

        let customer = Customer(name: customerName)
        let request = Request(service: service)
        let designer = Designer(name: "May")
        RequestManager.sendRequest(send: request, from: customer, to: designer)
        
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
