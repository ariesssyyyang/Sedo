//
//  ViewPicController.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/3.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit
import Nuke
import Firebase

class ViewPicController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cell"
    var author: Designer?
    var currentMe: Customer?
    var imageUrlString: String?
    var post: [String: String] = [:]
    var editImage: UIImage?
    var content: String? {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UINib(nibName: "ViewPictureCell", bundle: Bundle.main), forCellWithReuseIdentifier: "picCell")
        collectionView?.register(UINib(nibName: "PortfolioContentCell", bundle: Bundle.main), forCellWithReuseIdentifier: "contentCell")
        collectionView?.register(UINib(nibName: "FooterView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerViewId")

        setupNavigationBar()

        setupBackground()

        fetchPostDescription()

    }

    // MARK: - Set up

    func setupNavigationBar() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-more"), style: .plain, target: self, action: #selector(handleMore))

        self.navigationItem.title = "Picture"
    }

    func setupBackground() {
        let backImageView = UIImageView()
        backImageView.contentMode = .scaleAspectFill
        if let urlString = imageUrlString, let url = URL(string: urlString) {
            backImageView.image = nil
            Nuke.loadImage(with: url, into: backImageView)
        }
        self.collectionView?.backgroundView = backImageView

        if currentMe?.id == author?.id {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backImageView.addSubview(blurEffectView)
        } else {
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backImageView.addSubview(blurEffectView)
        }

    }

    // MARK: - Fetch Data

    func fetchPostDescription() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("fail to get user id in viewPicController!")
            return
        }

        guard let postId = post["postId"] else {
            print("fail to get post id in viewPicController!")
            return
        }

        let portfolioRef = Database.database().reference().child("portfolio").child(uid).child(postId)
        portfolioRef.observe(.value) { (postSnapshot) in
            guard let postDict = postSnapshot.value as? [String: String] else {
                print("fail to get post dictionary in viewPicController!")
                return
            }

            guard let description = postDict["description"] else {
                print("fail to get post content from postDict!")
                return
            }

            self.content = description
        }
    }

    // MARK: - Actions

    @objc func handleMore() {

        if currentMe?.id == author?.id {

            editOrDelete()

        } else {

            handleReport()

        }

    }

    func editOrDelete() {
        let alert = UIAlertController(title: "Action", message: "Choose an action", preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
            print("Edit the image description")

            let editController = NewPostController()
            let editView = editController.inputContainerView

            editController.editButtonIsHidden = false
            editView.selectedButton.isHidden = true
            editView.doneButton.isHidden = true

            if let urlString = self.imageUrlString, let url = URL(string: urlString) {
                editView.selectedImage.image = nil
                Nuke.loadImage(with: url, into: editView.selectedImage)
            }

            if let content = self.content {
                editView.descriptionTextField.text = content
            }

            editView.editButton.addTarget(self, action: #selector(self.handleEdit(_:)), for: .touchUpInside)

            self.present(editController, animated: true, completion: nil)
        }
        alert.addAction(edit)

        let delete = UIAlertAction(title: "Delete", style: .destructive) { (_) in

            self.showDeleteAlert()

        }
        alert.addAction(delete)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

    func showDeleteAlert() {

        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure to delete this post?", preferredStyle: .alert)

        let titleString = NSMutableAttributedString(string: "Delete" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        deleteAlert.setValue(titleString, forKey: "attributedTitle")

        let messageString = NSMutableAttributedString(string: "Are you sure to delete this post?" as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])

        deleteAlert.setValue(messageString, forKey: "attributedMessage")

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            guard let authorId = self.author?.id else {
                print("no author id in delete alert action!")
                return
            }
            guard let postId = self.post["postId"] else {
                print("get no post id to delete!")
                return
            }

            PortfolioManager.deletePost(authorId: authorId, postId: postId)
            self.navigationController?.popViewController(animated: true)

            print("delete the post")
        })

        let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelDelete)

        self.present(deleteAlert, animated: true, completion: nil)
    }

    func handleReport() {
        let alert = UIAlertController(title: "Action", message: "Choose an action", preferredStyle: .actionSheet)

        let report = UIAlertAction(title: "Report this post", style: .destructive) { (_) in
            let deleteAlert = UIAlertController(title: "Report", message: "Please enter the reason to report this post.", preferredStyle: .alert)
            deleteAlert.addTextField(configurationHandler: { (textfield) in

                textfield.heightAnchor.constraint(equalToConstant: 100).isActive = true
                textfield.placeholder = "enter some reason ..."
            })

            let reportAction = UIAlertAction(title: "Done", style: .destructive, handler: { (_) in
                print("report the post")
            })

            let cancelReport = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            deleteAlert.addAction(reportAction)
            deleteAlert.addAction(cancelReport)

            self.present(deleteAlert, animated: true, completion: nil)

        }
        alert.addAction(report)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }

    @objc func handleEdit(_ sender: UIButton) {

        guard let editView = sender.superview as? NewPostView else {
            print("fail to get Done Button superview!")
            return
        }
        guard let revisedContent = editView.descriptionTextField.text else {
            print("fail to get revised content!")
            return
        }

        guard let authorId = self.author?.id else {
            print("fail to get author id when sending edit request!")
            return
        }
        guard let postId = self.post["postId"] else {
            print("fail to get post id when sending edit request!")
            return
        }

        PortfolioManager.editPost(authorId: authorId, postId: postId, edit: revisedContent)

        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UICollectionView DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case 0:
            guard let pictureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as? ViewPictureCell
            else { return ViewPictureCell() }
            if let urlString = imageUrlString, let url = URL(string: urlString) {
                pictureCell.selectedImageView.image = nil
                Nuke.loadImage(with: url, into: pictureCell.selectedImageView)
                return pictureCell
            } else {
                return pictureCell
            }

        default:
            guard let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as? PortfolioContentCell
            else { return PortfolioContentCell() }

            guard let content = self.content else {
                print("descrioption not found when complementing datasource!")
                return contentCell
            }

            contentCell.contentTextView.text = content

            return contentCell
        }

    }

/*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width, height: 300)
    }

    // MARK: - Set up Header

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerViewId", for: indexPath) as? FooterView
            else {
                print("fail to get the right footer view")
                return FooterView()
        }

        if let imageString = headerInfo["imageUrl"], let imageURL = URL(string: imageString) {
            header.profileImageView.image = nil
            Nuke.loadImage(with: imageURL, into: header.profileImageView)
        }

        switch kind {

        case UICollectionElementKindSectionFooter:

            if currentMe?.id != author?.id {

                return footer

            } else {

                return footer
            }

        default:
            assert(false, "Unexpected element kind")

        }
    }
*/
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenSize = UIScreen.main.bounds.size

        switch indexPath.section {
        case 0:
            return CGSize(width: screenSize.width - 20, height: screenSize.width - 20)
        default:
            return CGSize(width: screenSize.width, height: screenSize.height / 5)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0.0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0.0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        // margin between cells
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }

}
