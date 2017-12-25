//
//  PortfolioManager.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/22.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import Foundation
import Firebase

struct Portfolio {
    let description: String
    let imageUrl: String
}

class PortfolioManager {

    static func uploadImage(selectedImage image: UIImage, description text: String, uid: String) {

        let storageRef = Storage.storage().reference().child("portfolio").child(text)

        guard let uploadData = UIImagePNGRepresentation(image) else {
            print("fail to get data of image!")
            return
        }

        storageRef.putData(uploadData, metadata: nil) { (metaData, error) in

            if error != nil {
                print(error)
                return
            }

            guard let imageUrl = metaData?.downloadURL()?.absoluteString else {
                print("fail to get imageUrl")
                return
            }

            let post = ["imageUrl": imageUrl, "description": text]

            writePost(post: post, author: uid)

        }
        
    }

    static func writePost(post: [String: String], author: String) {

        let ref = Database.database().reference()

        let postRef = ref.child("portfolio").child(author).childByAutoId()

        postRef.updateChildValues(post)

    }
}