//
//  RequestManager.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import Foundation
import Firebase

struct Customer {
    let name: String
}

struct Designer {
    let name: String
}

struct Request {
    let service: String
    let id: String
}

class RequestManager {

    static func sendRequest(for service: String, from customer: Customer, to designer: Designer) {
        let date = self.requestDate()
        let ref = Database.database().reference().child("request")
        let childRef = ref.childByAutoId()
        let value = ["designer": designer.name, "customer": customer.name, "date": date, "service": service, "check": false] as [String : Any]
        childRef.updateChildValues(value) { (err, ref) in
            if err != nil {
                // Todo: error handling
                return
            }

            let requestId = childRef.key
            let designerRequestRef = Database.database().reference().child("designer-request").child(designer.name).child(requestId)
            let customerRequestRef = Database.database().reference().child("customer-request").child(customer.name).child(requestId)

            // optional values //
            let designerValue = ["customer": customer.name, "service": service, "date": date]
            let customerValue = ["designer": designer.name, "service": service, "date": date]
            designerRequestRef.updateChildValues(designerValue)
            customerRequestRef.updateChildValues(customerValue)
            // optional values //

        }
        
        

//        let designerRequestRef = Database.database().reference().child("designer_request").child(designer.name)
//        let requestRef = designerRequestRef.childByAutoId()
//        let value = ["customer": customer.name, "date": date, "service": service, "check": false] as [String : Any]
//        requestRef.updateChildValues(value) { (error, ref) in
            // Todo: error handling
//            if error != nil {
//                print(error)
//            }
            // new request //
//            print(ref.key)
//
//        }
    }

    static func fetchRequest(receipient: Designer) {

        let ref = Database.database().reference().child("request").child(receipient.name)
        ref.observe(.childAdded, with: { (snapshot) in

            guard
                let dictionary = snapshot.value as? [String: AnyObject],
                let customer = dictionary["customer"] as? String,
                let date = dictionary["date"] as? String,
                let service = dictionary["service"] as? String,
                let status = dictionary["check"] as? Bool
            else {
                print("fail to transform type to dictionary")
                return
            }

            print("got a new request from \(customer):\nservice:\(service)\ndate:\(date)\ncheck it:\(status)\n")

        }, withCancel: nil)

    }

    static func requestDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
