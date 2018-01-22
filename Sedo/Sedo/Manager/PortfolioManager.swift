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

        let randomString = UUID().uuidString

        let storageRef = Storage.storage().reference().child("portfolio").child(uid).child(randomString)

        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {
            print("fail to get data of image!")
            return
        }

        storageRef.putData(uploadData, metadata: nil) { (metaData, error) in

            if error != nil {
                return
            }

            guard let imageUrl = metaData?.downloadURL()?.absoluteString else {
                print("fail to get imageUrl")
                return
            }

            let createdDate = RequestManager.requestDate()

            let post = ["imageUrl": imageUrl, "description": text, "createdDate": createdDate]

            writePost(post: post, author: uid)

        }

    }

    static func writePost(post: [String: String], author: String) {

        let ref = Database.database().reference()

        let postRef = ref.child("portfolio").child(author).childByAutoId()

        postRef.updateChildValues(post)

    }

    static func editPost(authorId: String, postId: String, edit: String) {

        let ref = Database.database().reference()
        let postRef = ref.child("portfolio").child(authorId).child(postId)
        let value = ["description": edit]

        postRef.updateChildValues(value)
    }

    static func deletePost(authorId: String, postId: String) {

        let portfolioRef = Database.database().reference().child("portfolio")
        let postRef = portfolioRef.child(authorId).child(postId)

        postRef.removeValue()

    }
}
