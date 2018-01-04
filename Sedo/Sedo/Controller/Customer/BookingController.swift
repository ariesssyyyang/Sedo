//
//  BookingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class BookingController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let datePicker = UIDatePicker()
    let servicePicker = UIPickerView()
    var services: [Service] = []
    var designer: Designer?
    var customer: Customer?

    let bookingView: BookingView = {
        guard let view = UINib.load(nibName: "BookingView", bundle: nil) as? BookingView
        else {
            return BookingView()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDesignerServices()

        setupNavigationBar()

        setupDatePicker()

        setupServicePicker()

        setupBookingView()
    }

    // MARK: - Set Up

    func setupBookingView() {
        view.addSubview(bookingView)
        bookingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bookingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bookingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bookingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        bookingView.dateTextField.inputView = datePicker
        bookingView.serviceTextField.inputView = servicePicker
        bookingView.doneButton.addTarget(self, action: #selector(requestService), for: .touchUpInside)
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Booking"

    }

    // MARK: - Fetch Services

    func fetchDesignerServices() {
        guard let designerId = designer?.id else {
            print("fail to get designer id when fetch service info!")
            return
        }
        let ref = Database.database().reference().child("service").child(designerId)
        ref.observe(.value) { (snapshot) in
            self.services = []

            for child in snapshot.children {

                guard let child = child as? DataSnapshot else { return }

                let service = child.key

                guard
                    let serviceDict = child.value as? [String: AnyObject],
                    let price = serviceDict["price"] as? Int
                    else {
                        print("fail to fetch service detail!")
                        return
                }

                self.services.append(Service(service: service, price: price))

            }

        }
    }

    // MARK: - Set Up

    func setupDatePicker() {

        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        datePicker.date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let endDateTime = formatter.date(from: "2019-12-31")
        datePicker.minimumDate = Date()
        datePicker.maximumDate = endDateTime
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }

    func setupServicePicker() {
        servicePicker.delegate = self
        servicePicker.dataSource = self
    }

    // MARK: - Actions

    @objc func datePickerChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        bookingView.dateTextField.text = formatter.string(from: picker.date)
    }

    @objc func requestService() {
        guard
            let customer = customer,
            let designer = designer,
            let service = bookingView.serviceTextField.text,
            let date = bookingView.dateTextField.text
            else { return }

        RequestManager.sendRequest(for: service, from: customer, to: designer, date: date)
        self.navigationController?.popViewController(animated: true)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UITextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - UIPickerView DataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if services.count == 0 {
            return 1
        } else {
            return services.count + 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if services.count == 0 {
            return "- No service -"
        } else {
            if row == 0 {
                return "select a service"
            } else {
                let service = services[row - 1]
                return service.service + "  ($ \(service.price))"
            }
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if row != 0 {
            bookingView.serviceTextField.text = services[row - 1].service
        } else {
            bookingView.serviceTextField.text = nil
        }
//        if services.count == 0 {
//            bookingView.serviceTextField.text = nil
//        } else {
//            bookingView.serviceTextField.text = services[row].service
//        }

    }

}
