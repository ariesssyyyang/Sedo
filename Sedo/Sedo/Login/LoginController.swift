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
        let signinString = NSLocalizedString("Login", comment: "login button")
        loginView.signinButton.setTitle(signinString, for: .normal)
        loginView.signinButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)

        let newAccountString = NSLocalizedString("New Account", comment: "newaccount button")
        loginView.newAccountButton.setTitle(newAccountString, for: .normal)
        loginView.newAccountButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)

        let forgetString = NSLocalizedString("Forgot Password", comment: "forgot button")
        loginView.forgetButton.setTitle(forgetString, for: .normal)
        loginView.forgetButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func handleSignIn() {
        self.view.endEditing(true)

        guard
            let email = loginView.emailTextField.text,
            let password = loginView.passwordTextField.text
            else {
                print("something wrong when sign in")
                return
        }

        UserManager.signIn(withEmail: email, password: password, in: self)
    }

    @objc func handleRegister() {
        let registerController = RegisterController()
        self.present(registerController, animated: true, completion: nil)
    }

    @objc func handleForgotPassword() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let localTitle = NSLocalizedString("Password Reset", comment: "alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alert.setValue(titleString, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Enter a correct registered email address and you will receive an email to reset password.", comment: "alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])

        alert.setValue(messageString, forKey: "attributedMessage")

        alert.addTextField { (textfield) in

            let localString = NSLocalizedString("Enter email address ...", comment: "textfield in alert")
            textfield.placeholder = localString
            textfield.keyboardType = .emailAddress
            textfield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }

        let sendbuttonString = NSLocalizedString("Send", comment: "button in alert")
        let ok = UIAlertAction(title: sendbuttonString, style: .default) { (_) in

            if alert.textFields?.first?.text == "" {

                self.showTextfieldAlert()

            } else {

                guard let email = alert.textFields?.first?.text else { return }

                UserManager.resetPassword(email: email, vc: self)

                let sendAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                let sendGreen = UIColor(red: 42.0/255, green: 120.0/255, blue: 27.0/255, alpha: 1.0)

                let sendString = NSLocalizedString("Send", comment: "title in alert")
                let titleString = NSMutableAttributedString(string: sendString as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: sendGreen])
                sendAlert.setValue(titleString, forKey: "attributedTitle")

                let localMessage = NSLocalizedString("Please check your email to reset the password.", comment: "title in alert")
                let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])
                sendAlert.setValue(messageString, forKey: "attributedMessage")

                let localOk = NSLocalizedString("OK", comment: "button in alert")
                let ok = UIAlertAction(title: localOk, style: .default, handler: nil)
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

        let localCancel = NSLocalizedString("Cancel", comment: "button in alert")
        let cancel = UIAlertAction(title: localCancel, style: .cancel, handler: nil)
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

        let localTitle = NSLocalizedString("Error", comment: "title in alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.red])

        textfieldAlert.setValue(titleString, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Please enter an registered email address.", comment: "title in alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])

        textfieldAlert.setValue(messageString, forKey: "attributedMessage")

        let localOk = NSLocalizedString("OK", comment: "button in alert")
        let ok = UIAlertAction(title: localOk, style: .default, handler: nil)
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
