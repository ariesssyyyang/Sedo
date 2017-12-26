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

        view.addSubview(editView)

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
        editView.nameTextField.resignFirstResponder()
        editView.lineIdTextField.resignFirstResponder()
        editView.introductionTextField.resignFirstResponder()
    }

    // MARK: - Set Up

    func setupNavigationBar() {

        self.navigationItem.title = "Setting"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]

    }

    func setupEditView() {
        editView.imageSelectedButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func handleDone() {
        guard
            let designerId = Auth.auth().currentUser?.uid,
            let updatedName = editView.nameTextField.text,
            let updatedLineId = editView.lineIdTextField.text,
            let updatedImage = editView.designerImageView.image
        else {
            print("fail to get updated designer info!")
            return
        }
        UserManager.uploadImage(selectedImage: updatedImage, name: updatedName, uid: designerId, lineId: updatedLineId)
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
