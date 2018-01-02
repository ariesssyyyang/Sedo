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

}
