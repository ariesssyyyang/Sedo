//
//  RegisterController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/20.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    let registerView: RegisterView = {
        guard let view = UINib.load(nibName: "RegisterView", bundle: Bundle.main) as? RegisterView else { return RegisterView() }
        return view
    }()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "user name"
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "email"
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.textAlignment = .center
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
/*
    let signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign in", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
*/
    let registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    @objc func handleSignUp() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = nameTextField.text
        else {
            print("please enter something!")
            return
        }
        UserManager.signUp(withEmail: email, password: password, name: username)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()

        setupRegisterView()

//        setupContainerView()
//        setupButtons()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupButtons() {

        let screenSize = UIScreen.main.bounds
        view.addSubview(registerButton)
        registerButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 50).isActive = true
        registerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: screenSize.width / 4).isActive = true
        registerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -(screenSize.width / 4)).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }

    var containerViewTopAnchor: NSLayoutConstraint?

    func setupContainerView() {

        let screenSize = UIScreen.main.bounds

        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: screenSize.height / 12).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -(screenSize.height / 12)).isActive = true
        containerViewTopAnchor = containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenSize.height / 4)
        containerViewTopAnchor?.isActive = true
        containerView.heightAnchor.constraint(equalToConstant: screenSize.height / 4).isActive = true

        containerView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3).isActive = true

        containerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3).isActive = true

        containerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3).isActive = true
    }

    // MARK: - Set Up
    
    func setupBackground() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = #imageLiteral(resourceName: "back-blurcity")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        let backView = UIView(frame: backgroundImageView.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        backgroundImageView.addSubview(backView)
    }
    
    func setupRegisterView() {
        view.addSubview(registerView)
        registerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        registerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
