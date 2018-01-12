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

    var editButtonIsHidden: Bool = true

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

        setupContainerView()

        setupButtons()

    }

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
        inputContainerView.editButton.isHidden = editButtonIsHidden
    }

    @objc func showImagePicker() {

        let localTitle = NSLocalizedString("Select photo", comment: "new post page")
        let localMessage = NSLocalizedString("Choose a method to select photo.", comment: "new post page")
        let alert = UIAlertController(title: localTitle, message: localMessage, preferredStyle: .actionSheet)

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

        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)

    }

    @objc func handleCancel() {
        let localTitle = NSLocalizedString("Notice", comment: "cancel new post")
        let title = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        let localMessage = NSLocalizedString("If you close now, your edits will be discarded.", comment: "cancel new post")
        let alert = UIAlertController(title: "", message: localMessage, preferredStyle: .alert)

        alert.setValue(title, forKey: "attributedTitle")
        let localExit = NSLocalizedString("Exit", comment: "cancel new post")
        let close = UIAlertAction(title: localExit, style: .destructive) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(close)
        let localCancel = NSLocalizedString("Cancel", comment: "cancel new post")
        let cancel = UIAlertAction(title: localCancel, style: .cancel, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)

    }

    @objc func handleDone() {
        // Todo: Send Error handling
        guard
            let image = inputContainerView.selectedImage.image,
            let text = inputContainerView.descriptionTextField.text
        else {
            print("invalid portfolio data")
            showNoImageAlert()
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail to get current user id before calling portfolio manager!")
            return
        }

        PortfolioManager.uploadImage(selectedImage: image, description: text, uid: uid)

        self.dismiss(animated: true, completion: nil)
    }

    func showNoImageAlert() {
        let localTitle = NSLocalizedString("Error", comment: "no image in new post")
        let title = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        let localMessage = NSLocalizedString("Please choose a picture to upload.", comment: "no image in new post")
        let alert = UIAlertController(title: "", message: localMessage, preferredStyle: .alert)
        alert.setValue(title, forKey: "attributedTitle")
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
