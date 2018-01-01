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

        guard let view = UINib.load(nibName: "RegisterView", bundle: Bundle.main) as? RegisterView
        else { return RegisterView() }

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()

        setupRegisterView()

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

    func setupRegisterView() {
        view.addSubview(registerView)
        registerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        registerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setupButtons() {
        registerView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        registerView.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func handleSignUp() {
        guard
            let email = registerView.emailTextField.text,
            let password = registerView.passwordTextField.text,
            let username = registerView.usernameTextField.text
            else {
                print("please enter something!")
                return
        }
        UserManager.signUp(withEmail: email, password: password, name: username)
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
