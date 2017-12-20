//
//  UserManager.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct User {

    let id: String
    let username: String

}

class UserManager {

    static func signIn(withEmail email: String, password: String) {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if let error = error {
                print("** fail to Sign in **")
                print(error)
            }

            if let user = user {
                print("** sing-in uid: \(user.uid) **")
                print("** Sign in successfully **")

                let customerTabBarController = CustomerTabBarController(itemTypes: [.main, .order, .profile])

                AppDelegate.shared.window?.updateRoot(
                    to: customerTabBarController,
                    animation: crossDissolve,
                    completion: nil
                )
            }

        }

    }

    static func signUp(withEmail email: String, password: String, name: String) {

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

            guard let user = user else {
                print("** fail to sign up **")
                return
            }

            user.sendEmailVerification(completion: { (error) in

                if error == nil {

                    let id = user.uid
                    let ref = Database.database().reference().child("user").child(id)
                    let value = ["name": name]

                    ref.updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let err = error {
                            print("** fail to update user info to database **")
                            print(err)
                        }

                    })

                } else {
                    print("** something went wrong to verify email **")
                }

            })

        }
    }

    static func signOut() {

        do {

            try Auth.auth().signOut()

            let loginController = LoginController()

            AppDelegate.shared.window?.updateRoot(
                to: loginController,
                animation: crossDissolve,
                completion: nil
            )

        } catch let signOutError {

            print(signOutError)

        }

    }
}
