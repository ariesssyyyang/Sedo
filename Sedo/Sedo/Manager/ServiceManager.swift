//
//  ServiceManager.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import Foundation
import Firebase

struct Service {

    let service: String

    let price: Int

}

class ServiceManager {

    static func addNew(service: String, price: Int) {

        guard let uid = Auth.auth().currentUser?.uid else {

            print("fail to get user id in service manager!")

            return
        }

        let serviceRef = Database.database().reference().child("service").child(uid).child(service)

        let value = ["price": price]

        serviceRef.updateChildValues(value)

    }

    static func getCurrency(priceString: String) {

        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
    }

}
