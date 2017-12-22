//
//  NewPostController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/21.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import ALCameraViewController
import Photos

class NewPostController: UIViewController, UITextFieldDelegate {

    let inputContainerView: NewPostView = {

        guard let view = UINib.load(nibName: "NewPostView", bundle: nil) as? NewPostView else { return NewPostView() }
        return view

    }()

    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = true
    var minimumSize: CGSize = CGSize(width: 90, height: 90)

    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Keyboard Notification
/*
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
*/

        setupContainerView()

        setupButtons()

    }
/*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }

    func adjustingHeight(show: Bool, notification: NSNotification) {
        var userInfo = notification.userInfo!
        guard let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion) {
            self.inputContainerView.textFieldBottomConstraint.constant -= changeInHeight
        }
    }
*/
    // MARK: - TextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        inputContainerView.descriptionTextField.resignFirstResponder()
    }

    // MARK: - Set Up

    func setupContainerView() {

        view.addSubview(inputContainerView)

        inputContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        inputContainerView.descriptionTextField.delegate = self

    }

    func setupButtons() {

        inputContainerView.selectedButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        inputContainerView.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        inputContainerView.doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    }

    @objc func showImagePicker() {

        let alert = UIAlertController(title: "Choose a method", message: "choose a method to select image", preferredStyle: .actionSheet)

        let shot = UIAlertAction(title: "Camera", style: .default) { (_) in
            print("open camera")

            let cameraViewController = CameraViewController(croppingParameters: self.croppingParameters, allowsLibraryAccess: false, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { [weak self] image, _ in

                self?.inputContainerView.selectedImage.image = image
                self?.inputContainerView.selectedImage.contentMode = .scaleAspectFill

                self?.dismiss(animated: true, completion: nil)
            })

            self.present(cameraViewController, animated: true, completion: nil)

        }
        alert.addAction(shot)

        let library = UIAlertAction(title: "Album", style: .default) { (_) in
            print("open photo library")

            let librartViewController = CameraViewController.imagePickerViewController(croppingParameters: self.croppingParameters) { [weak self] image, _ in
                self?.inputContainerView.selectedImage.image = image
                self?.inputContainerView.selectedImage.contentMode = .scaleAspectFill
                self?.dismiss(animated: true, completion: nil)
            }

            self.present(librartViewController, animated: true, completion: nil)

        }
        alert.addAction(library)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)

    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleDone() {
        // Todo: Send Image Data
        guard
            let image = inputContainerView.selectedImage.image,
            let text = inputContainerView.descriptionTextField.text
        else {
            print("invalid portfolio data")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail to get current user id before calling portfolio manager!")
            return
        }

        PortfolioManager.uploadImage(selectedImage: image, description: text, uid: uid)

        self.dismiss(animated: true, completion: nil)
    }

}
