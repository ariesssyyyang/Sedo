//
//  LoginView.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/1.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class LoginView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signinButton: UIButton!

    @IBOutlet weak var forgetButton: UIButton!

    @IBOutlet weak var newAccountButton: UIButton!

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {

        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = UIColor.clear

        setupButtons()

        setupContainerView()

        setupImageView()
    }

    // MARK: - Set up

    func setupButtons() {
        signinButton.layer.cornerRadius = signinButton.frame.size.height / 2
        signinButton.layer.masksToBounds = true
    }

    func setupContainerView() {

        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 50
        containerView.layer.shadowOpacity = 0.5
        containerView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)

        emailTextField.backgroundColor = UIColor.clear

        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.isSecureTextEntry = true
    }

    func setupImageView() {

    }

}
