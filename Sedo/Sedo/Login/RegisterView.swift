//
//  RegisterView.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/1.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class RegisterView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.clear
        
        setupButtons()

        setupContainerView()
    }

    // MARK: - Set up

    func setupButtons() {
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        signUpButton.layer.masksToBounds = true
    }
    
    func setupContainerView() {
        
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 50
        containerView.layer.shadowOpacity = 0.5
        containerView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)

        usernameTextField.backgroundColor = UIColor.clear

        emailTextField.backgroundColor = UIColor.clear
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.isSecureTextEntry = true
    }
}
