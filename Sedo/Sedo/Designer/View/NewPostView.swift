//
//  NewPostView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/21.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class NewPostView: UIView {
    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var selectedImage: UIImageView!

    @IBOutlet weak var selectedButton: UIButton!

    @IBOutlet weak var descriptionTextField: UITextField!

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false

        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)
        placeholderImageView.tintColor = UIColor.lightGray

        let screenSize = UIScreen.main.bounds.size
        let textfieldHeight = screenSize.height - doneButton.frame.height - selectedImage.frame.height

        descriptionTextField.heightAnchor.constraint(equalToConstant: textfieldHeight).isActive = true

        setupButtons()
    }

    func setupButtons() {

        let localDone = NSLocalizedString("Done", comment: "new post page")
        doneButton.setTitle(localDone, for: .normal)

        let localEdit = NSLocalizedString("Edit", comment: "new post page")
        editButton.setTitle(localEdit, for: .normal)

        let localCancel = NSLocalizedString("Cancel", comment: "new post page")
        cancelButton.setTitle(localCancel, for: .normal)

    }

}
