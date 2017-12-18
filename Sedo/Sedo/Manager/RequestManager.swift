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
    let customer: Customer
    let designer: Designer
    let createdDate: String
    let date: String
}

struct Order {
    let service: String
    let id: String
    let date: String
}

class RequestManager {

    static func sendRequest(for service: String, from customer: Customer, to designer: Designer, date: String) {
        let createDate = self.requestDate()
        let ref = Database.database().reference().child("request")
        let childRef = ref.childByAutoId()
        let value = ["designer": designer.name, "customer": customer.name, "createdDate": createDate, "date": date, "service": service, "check": false] as [String: Any]

        childRef.updateChildValues(value) { (err, _) in

            if err != nil {
                // Todo: error handling
                return
            }

            let requestId = childRef.key
            let designerRequestRef = Database.database().reference().child("request-designer").child(designer.name).child(requestId)
            let customerRequestRef = Database.database().reference().child("request-customer").child(customer.name).child(requestId)

            // optional values //
            let designerValue = ["customer": customer.name, "service": service, "date": date, "createdDate": createDate]
            let customerValue = ["designer": designer.name, "service": service, "date": date, "createdDate": createDate]
            designerRequestRef.updateChildValues(designerValue)
            customerRequestRef.updateChildValues(customerValue)
            // optional values //

        }
    }

    static func sendOrder(of request: Request) {

        let ref = Database.database().reference().child("order")
        let childRef = ref.childByAutoId()

        let designer = request.designer.name,
            customer = request.customer.name,
            service = request.service,
            date = request.date

        let value = ["designer": designer, "customer": customer, "service": service, "date": date]

        childRef.updateChildValues(value) { (error, _) in
            if error != nil {
                // Todo: error handling
                return
            }

            let orderId = childRef.key
            let designerOrderRef = Database.database().reference().child("order-designer").child(designer).child(orderId)
            let customerOrderRef = Database.database().reference().child("order-customer").child(customer).child(orderId)

            // optional value //
            let designerValue = ["customer": customer, "service": service, "date": date]
            let customerValue = ["designer": designer, "service": service, "date": date]
            designerOrderRef.updateChildValues(designerValue)
            customerOrderRef.updateChildValues(customerValue)
            // optional value //

        }
    }

    static func approveRequest(for request: Request) {
        print("request \(request.service) is going to be approved")
        let ref = Database.database().reference()
        let requestRef = ref.child("request")
        requestRef.observeSingleEvent(of: .value) { (snapshot) in

            guard
                let dictionary = snapshot.value as? [String: AnyObject],
                let requestDic = dictionary[request.id] as? [String: AnyObject],
                let customer = requestDic["customer"] as? String,
                let designer = requestDic["designer"] as? String
            else { return }
            let designerRequestRef = ref.child("request-designer").child(designer)
            let customerRequestRef = ref.child("request-customer").child(customer)
            designerRequestRef.child(request.id).removeValue()
            customerRequestRef.child(request.id).removeValue()
            requestRef.child(request.id).removeValue()
        }

        print("request \(request.service) approved successfully")
    }

    static func rejectRequest(for request: Request) {
        print("request \(request.service) is going to be deleted")
        let ref = Database.database().reference()
        let requestRef = ref.child("request")
        requestRef.observeSingleEvent(of: .value) { (snapshot) in

            guard
                let dictionary = snapshot.value as? [String: AnyObject],
                let requestDic = dictionary[request.id] as? [String: AnyObject],
                let customer = requestDic["customer"] as? String,
                let designer = requestDic["designer"] as? String
            else { return }
            let designerRequestRef = ref.child("request-designer").child(designer)
            let customerRequestRef = ref.child("request-customer").child(customer)
            designerRequestRef.child(request.id).removeValue()
            customerRequestRef.child(request.id).removeValue()
            requestRef.child(request.id).removeValue()
        }
        print("request \(request.service) deleted successfully")
    }
/*
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
*/
    static func requestDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
