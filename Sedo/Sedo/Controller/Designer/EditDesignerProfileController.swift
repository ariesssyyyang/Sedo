//
//  EditDesignerProfileController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/24.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import ALCameraViewController
import Firebase

class EditDesignerProfileController: UIViewController, UITextFieldDelegate {

    let editView: DesignerEditView = {
        guard let view = UINib.load(nibName: "DesignerEditView", bundle: nil) as? DesignerEditView
        else {
            return DesignerEditView()
        }
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

        view.backgroundColor = UIColor.white

        setupEditView()

        confirmDelegate()

        setupNavigationBar()

    }

    // MARK: - TextFieldDelegate

    func confirmDelegate() {

        editView.nameTextField.delegate = self
        editView.lineIdTextField.delegate = self
        editView.introductionTextField.delegate = self

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.view.endEditing(true)

    }

    // MARK: - Set Up

    func setupNavigationBar() {

        let titleString = NSLocalizedString("Setting", comment: "designer edit profile navigation bar")
        self.navigationItem.title = titleString

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icon-check"),
            style: .plain,
            target: self,
            action: #selector(handleDone)
        )

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(handleCancel)
        )

    }

    func setupEditView() {

        view.addSubview(editView)
        editView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        editView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        editView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        editView.imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)

        let selectString = NSLocalizedString("select image", comment: "")
        editView.imageSelectedButton.setTitle(selectString, for: .normal)
        editView.imageSelectedButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func handleDone() {
        guard
            let designerId = Auth.auth().currentUser?.uid,
            let updatedName = editView.nameTextField.text,
            let updatedLineId = editView.lineIdTextField.text,
            let introduction = editView.introductionTextField.text
        else {
            print("fail to get updated designer info!")
            return
        }
        print(designerId)
        print(updatedName)
        print(updatedLineId)

        if let updatedImage = editView.designerImageView.image {
            UserManager.uploadImage(selectedImage: updatedImage, name: updatedName, uid: designerId, lineId: updatedLineId, introduction: introduction)
        } else {
            UserManager.uploadImage(selectedImage: nil, name: updatedName, uid: designerId, lineId: updatedLineId, introduction: introduction)
        }

        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func selectImage() {
        let alert = UIAlertController(title: "Choose a method", message: "choose a method to select image", preferredStyle: .actionSheet)

        let shot = UIAlertAction(title: "Camera", style: .default) { (_) in
            print("open camera")

            let cameraViewController = CameraViewController(croppingParameters: self.croppingParameters, allowsLibraryAccess: false, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { [weak self] image, _ in

                self?.editView.designerImageView.image = image
                self?.editView.designerImageView.contentMode = .scaleAspectFill

                self?.dismiss(animated: true, completion: nil)
            })

            self.present(cameraViewController, animated: true, completion: nil)

        }
        alert.addAction(shot)

        let library = UIAlertAction(title: "Album", style: .default) { (_) in
            print("open photo library")

            let librartViewController = CameraViewController.imagePickerViewController(croppingParameters: self.croppingParameters) { [weak self] image, _ in
                self?.editView.designerImageView.image = image
                self?.editView.designerImageView.contentMode = .scaleAspectFill
                self?.dismiss(animated: true, completion: nil)
            }

            self.present(librartViewController, animated: true, completion: nil)

        }
        alert.addAction(library)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

}
