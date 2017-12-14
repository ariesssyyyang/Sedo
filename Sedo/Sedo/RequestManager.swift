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
    
}

struct Designer {
    
}

struct Request {
    
}

class RequestManager {

    static func sendRequest(send request: Request, from customer: Customer, to designer: Designer) {
        let date = self.requestDate()
        let ref = Database.database().reference().child("request").child("Andy")
        let requestRef = ref.childByAutoId()
        let value = ["customer": "cow", "date": date, "service": "tatoo", "check": false] as [String : Any]
        requestRef.updateChildValues(value) { (error, ref) in
            // Todo: error handling
            if error != nil {
                print(error)
            }
            // new request //
            print(ref.key)

        }
    }

    static func fetchRequest(receipient: Designer) {
        let ref = Database.database().reference().child("request").child("Andy")
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
