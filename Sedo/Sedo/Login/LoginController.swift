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

    let loginView: LoginView = {
        guard let view = UINib.load(nibName: "LoginView", bundle: Bundle.main) as? LoginView else { return LoginView() }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()

        setupLoginView()

        setupButtons()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

    func setupLoginView() {
        view.addSubview(loginView)
        loginView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loginView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setupButtons() {
        loginView.signinButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        loginView.newAccountButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        loginView.forgetButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func handleSignIn() {
        guard
            let email = loginView.emailTextField.text,
            let password = loginView.passwordTextField.text
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

    @objc func handleForgotPassword() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "Password Reset" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alert.setValue(titleString, forKey: "attributedTitle")
        
        let messageString = NSMutableAttributedString(string: "Enter a correct registered email address and you will receive an email to reset password." as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])

        alert.setValue(messageString, forKey: "attributedMessage")

        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter ..."
            textfield.keyboardType = .emailAddress
            textfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        let ok = UIAlertAction(title: "Send", style: .default) { (_) in

            if alert.textFields?.first?.text == "" {

                self.showTextfieldAlert()

            } else {

                guard let email = alert.textFields?.first?.text else { return }

                UserManager.resetPassword(email: email)

                let sendAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                let sendGreen = UIColor(red: 42.0/255, green: 120.0/255, blue: 27.0/255, alpha: 1.0)
                let titleString = NSMutableAttributedString(string: "Send" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: sendGreen])
                sendAlert.setValue(titleString, forKey: "attributedTitle")

                let messageString = NSMutableAttributedString(string: "Please check your email to reset the password." as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])
                sendAlert.setValue(messageString, forKey: "attributedMessage")

                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                sendAlert.addAction(ok)

                sendAlert.view.tintColor = UIColor(
                    red: 24.0 / 255.0,
                    green: 79.0 / 255.0,
                    blue: 135 / 255.0,
                    alpha: 1.0
                )

                self.present(sendAlert, animated: true, completion: nil)

            }
        }
        alert.addAction(ok)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)

        alert.view.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        self.present(alert, animated: true, completion: nil)
    }

    func showTextfieldAlert() {

        let textfieldAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "Error" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.red])

        textfieldAlert.setValue(titleString, forKey: "attributedTitle")

        let messageString = NSMutableAttributedString(string: "Please enter an registered email address." as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])

        textfieldAlert.setValue(messageString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        textfieldAlert.addAction(ok)

        textfieldAlert.view.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        self.present(textfieldAlert, animated: true, completion: nil)

    }

}
