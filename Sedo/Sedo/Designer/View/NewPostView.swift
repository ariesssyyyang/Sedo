//
//  NewPostView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/21.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class NewPostView: UIView {

    @IBOutlet weak var selectedImage: UIImageView!

    @IBOutlet weak var selectedButton: UIButton!

    @IBOutlet weak var descriptionTextField: UITextField!

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
