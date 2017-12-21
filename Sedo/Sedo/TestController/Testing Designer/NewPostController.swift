//
//  NewPostController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/21.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import ALCameraViewController
import Photos

class NewPostController: UIViewController {

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
//        let screenSize = UIScreen.main.bounds.size
//        let square = CGSize(width: screenSize.width, height: screenSize.width)
//        print(square.width)
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView()

        setupButtons()
        
    }

    // MARK: - Set Up

    func setupContainerView() {

        view.addSubview(inputContainerView)

        inputContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        inputContainerView.selectedImage.contentMode = .scaleAspectFill
    }

    func setupButtons() {

        inputContainerView.selectedButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        inputContainerView.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        inputContainerView.doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    }

    @objc func showImagePicker() {

        let librartViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            self?.inputContainerView.selectedImage.image = image
            self?.dismiss(animated: true, completion: nil)
        }

        self.present(librartViewController, animated: true, completion: nil)
    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleDone() {
        // Todo: Send Image Data
        self.dismiss(animated: true, completion: nil)
    }

}
