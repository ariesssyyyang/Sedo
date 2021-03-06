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

    static func signIn(withEmail email: String, password: String, in viewController: UIViewController) {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if let error = error {
                print("** fail to Sign in **")
                print(error.localizedDescription)
                showAlert(inVC: viewController, description: error.localizedDescription)
            }

            if let user = user {
                print("** sing-in uid: \(user.uid) **")
                print("** Sign in successfully **")

                let customerTabBarController = CustomerTabBarController(itemTypes: [.main, .order, .profile])

                DispatchQueue.main.async {
                    AppDelegate.shared.window?.updateRoot(
                        to: customerTabBarController,
                        animation: crossDissolve,
                        duration: 1.0,
                        completion: nil
                    )
                }

            }

        }

    }

    static func signUp(withEmail email: String, password: String, name: String, vc: UIViewController) {

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

            if let error = error {
                showAlert(inVC: vc, description: error.localizedDescription)
            }

            guard let user = user else {
                print("** fail to sign up **")
                return
            }

            user.sendEmailVerification(completion: { (error) in

                if let err = error {

                    print("** something went wrong to verify email **")
                    showAlert(inVC: vc, description: err.localizedDescription)

                } else {

                    let id = user.uid
                    let ref = Database.database().reference().child("user").child(id)
                    let value = ["name": name]

                    ref.updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let err = error {
                            print("** fail to update user info to database **")
                            print(err)
                        }

                        let customerTabBarController = CustomerTabBarController(itemTypes: [.main, .order, .profile])

                        DispatchQueue.main.async {
                            AppDelegate.shared.window?.updateRoot(
                                to: customerTabBarController,
                                animation: crossDissolve,
                                duration: 1.0,
                                completion: nil
                            )
                        }

                    })

                }

            })

        }
    }

    static func uploadImage(selectedImage image: UIImage?, name: String, uid: String, lineId: String, introduction: String) {

        let storageRef = Storage.storage().reference().child("designer").child(uid)

        if let image = image, let uploadData = UIImageJPEGRepresentation(image, 0.5) {

            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in

                if error != nil {
                    return
                }

                guard let imageUrl = metaData?.downloadURL()?.absoluteString else {
                    print("fail to get imageUrl")
                    return
                }

                let designerInfo = ["profileImageUrl": imageUrl, "name": name, "lineId": lineId, "introduction": introduction]

                updateDesignerInfo(info: designerInfo, designerId: uid)

            }

        } else {

            let designerInfo = ["name": name, "lineId": lineId, "introduction": introduction]

            updateDesignerInfo(info: designerInfo, designerId: uid)
        }

    }

    static func updateDesignerInfo(info: [String: String], designerId: String) {

        let ref = Database.database().reference()

        let userRef = ref.child("user").child(designerId)

        userRef.updateChildValues(info)

    }

    static func resetPassword(email: String, vc: UIViewController) {

        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print(error)
                showAlert(inVC: vc, description: error.localizedDescription)
            }
        }
    }

    static func signOut(viewController: UIViewController) {

        do {

            try Auth.auth().signOut()

            let loginController = LoginController()

            AppDelegate.shared.window?.updateRoot(
                to: loginController,
                animation: crossDissolve,
                duration: 0.8,
                completion: nil
            )

        } catch let signOutError {

            print(signOutError)
            showAlert(inVC: viewController, description: signOutError.localizedDescription)

        }

    }

    static func showAlert(inVC viewController: UIViewController, description: String) {

        let loginAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let localTitle = NSLocalizedString("Error", comment: "alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.red])
        loginAlert.setValue(titleString, forKey: "attributedTitle")

        let localMessage = NSLocalizedString(description, comment: "alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])
        loginAlert.setValue(messageString, forKey: "attributedMessage")

        let okString = NSLocalizedString("OK", comment: "alert action")
        let ok = UIAlertAction(title: okString, style: .default, handler: nil)
        loginAlert.addAction(ok)

        viewController.present(loginAlert, animated: true, completion: nil)
    }
}
