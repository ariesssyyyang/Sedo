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
        let datePlaceholder = NSLocalizedString("select a date", comment: "booking page textfield")
        bookingView.dateTextField.placeholder = datePlaceholder

        bookingView.serviceTextField.inputView = servicePicker
        let servicePlaceholder = NSLocalizedString("choose a service", comment: "booking page textfield")
        bookingView.serviceTextField.placeholder = servicePlaceholder

        let buttonString = NSLocalizedString("Done", comment: "done button in booking page")
        bookingView.doneButton.setTitle(buttonString, for: .normal)
        bookingView.doneButton.addTarget(self, action: #selector(showDoubleCheckAlert), for: .touchUpInside)
    }

    func setupNavigationBar() {

        let titleString = NSLocalizedString("Booking", comment: "booking page navigation bar")
        self.navigationItem.title = titleString

    }

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

    func showTextfieldAlert() {

        let textfieldAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let errorString = NSLocalizedString("Error", comment: "alert")
        let titleString = NSMutableAttributedString(string: errorString as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.red])

        textfieldAlert.setValue(titleString, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Please enter all infomations needed.", comment: "alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])

        textfieldAlert.setValue(messageString, forKey: "attributedMessage")

        let localOk = NSLocalizedString("OK", comment: "alert")
        let ok = UIAlertAction(title: localOk, style: .default, handler: nil)
        textfieldAlert.addAction(ok)

        self.present(textfieldAlert, animated: true, completion: nil)
    }

    @objc func datePickerChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        bookingView.dateTextField.text = formatter.string(from: picker.date)
    }

    @objc func showDoubleCheckAlert() {

        self.view.endEditing(true)

        if bookingView.serviceTextField.text == "" || bookingView.dateTextField.text == "" {

            showTextfieldAlert()

        } else {

            doneAlert()

        }
    }

    func requestService() {

        guard
                let customer = customer,
                let designer = designer,
                let service = bookingView.serviceTextField.text,
                let date = bookingView.dateTextField.text
                else { return }

            RequestManager.sendRequest(for: service, from: customer, to: designer, date: date)
            self.bookingSuccessAlert()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func doneAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let localTitle = NSLocalizedString("Notice", comment: "")
        let title = AlertManager.customizedTitle(title: localTitle)
        alert.setValue(title, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Press yes to book the service.", comment: "")
        let message = AlertManager.customizedMessage(message: localMessage)
        alert.setValue(message, forKey: "attributedMessage")

        let localCancel = NSLocalizedString("Cancel", comment: "")
        let cancelAction = UIAlertAction(title: localCancel, style: .default, handler: nil)
        alert.addAction(cancelAction)

        let localYes = NSLocalizedString("Yes", comment: "")
        let yesAction = UIAlertAction(title: localYes, style: .default) { (_) in
            self.requestService()
        }
        alert.addAction(yesAction)

        self.present(alert, animated: true, completion: nil)
    }

    func bookingSuccessAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let localTitle = NSLocalizedString("Success", comment: "")
        let title = AlertManager.successTitle(title: localTitle)
        alert.setValue(title, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Booking successfully, you can check it out in pending page.", comment: "")
        let message = AlertManager.customizedMessage(message: localMessage)
        alert.setValue(message, forKey: "attributedMessage")

        let localOk = NSLocalizedString("OK", comment: "")
        let okAction = UIAlertAction(title: localOk, style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)

        let localCheckout = NSLocalizedString("Check order", comment: "")
        let checkAction = UIAlertAction(title: localCheckout, style: .destructive) { (_) in

            self.navigationController?.popViewController(animated: true)

            guard let rootVC = self.navigationController?.viewControllers[0] as? CustomerMainPageController
            else {
                print("fail to get root VC in bookingPage")
                return
            }

            rootVC.tabBarController?.selectedIndex = 1
        }
        alert.addAction(checkAction)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Fetch Services

    func fetchDesignerServices() {

        guard let designerId = designer?.id else {
            print("fail to get designer id when fetch service info!")
            return
        }

        let ref = Database.database().reference().child("service").child(designerId)
        ref.observe(.value) { [weak self] (snapshot) in
            self?.services = []

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

                self?.services.append(Service(service: service, price: price))

            }

        }
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
            let titleString = NSLocalizedString("- No service -", comment: "in booking page")
            return titleString
        } else {
            if row == 0 {
                let titleString = NSLocalizedString("select a service", comment: "first row in service picker")
                return titleString
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

    }

}
