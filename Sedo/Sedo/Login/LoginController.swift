//
//  LoginController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    let signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign in", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create New", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10.0
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    @objc func handleSignIn() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            print("something wrong when sign in")
            return
        }

        UserManager.signIn(withEmail: email, password: password)
    }

    @objc func handleRegister() {
        let registerController = RegisterController()
        self.present(registerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Keyboard Notification

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)

        view.backgroundColor = UIColor.white
        setupContainerView()
        setupButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // MARK: - Check Login

        if Auth.auth().currentUser != nil {

            let customerTabBarController = CustomerTabBarController(itemTypes: [.main, .order, .profile])

            AppDelegate.shared.window?.updateRoot(
                to: customerTabBarController,
                animation: crossDissolve,
                completion: nil
            )
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }

    func adjustingHeight(show: Bool, notification: NSNotification) {
        var userInfo = notification.userInfo!
        guard let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let changeInHeight = (UIScreen.main.bounds.height / 8) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion) {
            self.containerViewTopAnchor?.constant -= changeInHeight
        }
    }

    func setupButtons() {

        let screenSize = UIScreen.main.bounds

        view.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 50).isActive = true
        signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: screenSize.width / 4).isActive = true
        signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -(screenSize.width / 4)).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(registerButton)
        registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
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

        containerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: screenSize.height / 12).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3).isActive = true

        containerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3).isActive = true
    }

}
