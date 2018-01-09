//
//  DesignerEditView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/26.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class DesignerEditView: UIView {

    @IBOutlet weak var designerImageView: UIImageView!

    @IBOutlet weak var imageSelectedButton: UIButton!

    @IBOutlet weak var imageButton: UIButton!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var lineIdTextField: UITextField!

    @IBOutlet weak var introductionTextField: UITextField!

    @IBOutlet weak var placeholderImageView: UIImageView!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false

        setupBackground()

        setupImageView()

        setupTextFields()
    }

    // MARK: - Set up

    func setupImageView() {

        placeholderImageView.image = #imageLiteral(resourceName: "icon-alien").withRenderingMode(.alwaysTemplate)
        placeholderImageView.tintColor = UIColor.lightGray
        placeholderImageView.layer.borderWidth = 1
        placeholderImageView.layer.borderColor = UIColor.lightGray.cgColor
        placeholderImageView.layer.cornerRadius = placeholderImageView.frame.size.width / 2
        placeholderImageView.clipsToBounds = true

        designerImageView.layer.borderWidth = 1
        designerImageView.layer.borderColor = UIColor.lightGray.cgColor
        designerImageView.layer.cornerRadius = designerImageView.frame.size.width / 2
        designerImageView.clipsToBounds = true

    }

    func setupBackground() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }

    func setupTextFields() {
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.cornerRadius = 10

        lineIdTextField.layer.borderWidth = 1.0
        lineIdTextField.layer.borderColor = UIColor.lightGray.cgColor
        lineIdTextField.layer.cornerRadius = 10

        introductionTextField.layer.borderWidth = 1.0
        introductionTextField.layer.borderColor = UIColor.lightGray.cgColor
        introductionTextField.layer.cornerRadius = 10
    }

    func setupButton() {
        imageButton.layer.cornerRadius = imageButton.frame.height / 2
        imageButton.layer.masksToBounds = true

        let localTitle = NSLocalizedString("select image", comment: "")
        imageSelectedButton.setTitle(localTitle, for: .normal)
    }

}
