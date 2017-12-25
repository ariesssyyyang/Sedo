//
//  BookingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class BookingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions

    var designer: Designer?
    var customer: Customer?
 /*
    @objc func requestService() {
        guard
            let customer = customer,
            let designer = designer,
            let service = serviceTextField.text,
            let date = dateTextField.text
            else { return }
        
        RequestManager.sendRequest(for: service, from: customer, to: designer, date: date)
        self.navigationController?.popViewController(animated: true)
        
    }
*/
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
