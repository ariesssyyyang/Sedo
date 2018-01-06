//
//  PortfolioController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class PortfolioController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let portfolioCellId = "portfolioCell"
    var author: Designer?
    var currentMe: Customer?
    var images: [String] = []
    var postInfo: [String: [String: String]] = [:]
    var headerInfo: [String: String] = [:]
    var mainPageController: CustomerMainPageController?

    override func viewDidLoad() {

        super.viewDidLoad()

        checkRootVC()

        setupNavigationBar()

        if author == nil {
            fetchMe()
        }

        fetchPortfolio()

        fetchHeaderInfo()

        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white

        collectionView?.register(UINib(nibName: "PortfolioCell", bundle: Bundle.main), forCellWithReuseIdentifier: portfolioCellId)

        collectionView?.register(UINib(nibName: "PortfolioIntroView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerViewId")

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-walkman"))
        backgroundImageView.contentMode = .scaleAspectFill
        collectionView?.backgroundView = backgroundImageView

        let blackView = UIView()
        blackView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        blackView.frame = backgroundImageView.frame
        backgroundImageView.addSubview(blackView)
    }

    // MARK: - Check

    func checkRootVC() {
        if mainPageController == nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: #imageLiteral(resourceName: "icon-mode"),
                style: .plain,
                target: self,
                action: #selector(changeMode)
            )
        } else {
            return
        }

    }

    // MARK: - Fetch Data

    func fetchMe() {

        guard let myUid = Auth.auth().currentUser?.uid else { return }

        let ref = Database.database().reference().child("user").child(myUid)
        ref.observe(.value) { (mySnapshot) in
            guard
                let nameDict = mySnapshot.value as? [String: String],
                let myName = nameDict["name"]
            else {
                print("fail to get customer name in portfolio page!")
                return
            }

            self.author = Designer(name: myName, id: myUid)
            self.currentMe = Customer(name: myName, id: myUid)

        }
    }

    func fetchHeaderInfo() {
        let ref = Database.database().reference()
        let userRef = ref.child("user")

        userRef.observe(.value) { (userSnapshot) in

            guard
                let userDict = userSnapshot.value as? [String: AnyObject],
                let uid = self.author?.id,
                let user = userDict[uid] as? [String: String]
            else {
                print("fail to get basic user info!")
                return
            }

            if let name = user["name"] {
                self.headerInfo.updateValue(name, forKey: "name")
            } else {
                print("fail to get designer name")
            }

            if let lineId = user["lineId"] {
                self.headerInfo.updateValue(lineId, forKey: "lineId")
            } else {
                print("fail to get designer lineId")
            }

            if let profileImageUrl = user["profileImageUrl"] {
                self.headerInfo.updateValue(profileImageUrl, forKey: "imageUrl")
            } else {
                print("fail to get designer profile image!")
            }

            if let introduction = user["introduction"] {
                self.headerInfo.updateValue(introduction, forKey: "introduction")
            }
            else {
                print("fail to get designer introduction!")
            }

        }

    }

    func fetchPortfolio() {
        let ref = Database.database().reference()
        let userRef = ref.child("user")

        userRef.observe(.value) { (userSnapshot) in
            guard
                let uid = self.author?.id
            else {
                print("fail get user id in portfolio page!")
                return
            }
 
            let portfolioRef = ref.child("portfolio").child(uid)
            portfolioRef.observe(.value, with: { (portfolioSnapshot) in
                self.images = []
                for child in portfolioSnapshot.children {

                    guard let child = child as? DataSnapshot else { return }

                    let postKey = child.key

                    guard
                        let postDict = child.value as? [String: String]
                        else {
                            print("fail to get postDict in fetchPortfolio function!")
                            return
                    }

                    guard let imageUrl = postDict["imageUrl"]
                        else {
                            print("fail to get imageUrl String in fetchPortfolio function!")
                            return
                    }

                    guard let imageDescription = postDict["description"]
                        else {
                            print("fail to get description in fetchPortfolio function!")
                            return
                    }

                    let post = ["postId": postKey, "content": imageDescription]

                    self.postInfo.updateValue(post, forKey: imageUrl)
                    self.images.insert(imageUrl, at: 0)
                }
                self.collectionView?.reloadData()
            })
        }
    }

    // MARK: - Set up

    func setupNavigationBar() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewPost))

        self.navigationItem.title = "Portfolio"

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Actions

    @objc func changeMode() {

        self.dismiss(animated: true, completion: nil)

    }

    @objc func handleNewPost() {

        print("new post")
        let controller = NewPostController()
        self.present(controller, animated: true, completion: nil)

    }

    @objc func handleEdit(_ sender: UIButton) {

        let editController = EditDesignerProfileController()

        editController.editView.nameTextField.text = headerInfo["name"]

        if let lineId = headerInfo["lineId"] {
            editController.editView.lineIdTextField.text = lineId
        }

        editController.editView.introductionTextField.text = headerInfo["introduction"]

        if let imageString = headerInfo["imageUrl"], let imageURL = URL(string: imageString) {
            editController.editView.designerImageView.image = nil
            Nuke.loadImage(with: imageURL, into: editController.editView.designerImageView)
        }

        let navigationController = DesignerNavigationController(rootViewController: editController)

        self.present(navigationController, animated: true, completion: nil)
    }

    @objc func handleServiceButton(_ sender: UIButton) {
        let serviceController = ServiceController()
        serviceController.designer = author
        serviceController.customer = currentMe
        self.navigationController?.pushViewController(serviceController, animated: true)
    }

    // MARK: - UICollectionView DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: portfolioCellId, for: indexPath) as? PortfolioCell else { return PortfolioCell() }

        let url = images[indexPath.row]

        if let imageURL = URL(string: url) {

            cell.portfolioImageView.image = nil

            Nuke.loadImage(with: imageURL, into: cell.portfolioImageView)

        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let viewController = ViewPicController(collectionViewLayout: UICollectionViewFlowLayout())

        let url = images[indexPath.row]

        if let post = postInfo[url] {
            viewController.post = post
        }

        viewController.imageUrlString = url
        viewController.author = self.author
        viewController.currentMe = self.currentMe

        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width, height: 200)
    }

    // MARK: - Set up Header

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewId", for: indexPath) as? PortfolioIntroView
        else {
            print("fail to get the right intro view")
            return PortfolioIntroView()
        }

        if author?.name != "" {
            header.nameLabel.text = author?.name
        }

        if let lineId = headerInfo["lineId"] {

            if lineId != "" {
                header.lineIdLabel.text = lineId
            } else {
                header.lineIdLabel.text = "N/A"
            }

        }

        if let introduction = headerInfo["introduction"] {
            header.introTextView.text = introduction
        }

        if let imageString = headerInfo["imageUrl"], let imageURL = URL(string: imageString) {
            header.profileImageView.image = nil
            Nuke.loadImage(with: imageURL, into: header.profileImageView)
        }

        switch kind {

        case UICollectionElementKindSectionHeader:

            if currentMe?.id != author?.id {

                self.collectionView?.backgroundView = nil

                self.navigationItem.rightBarButtonItem = nil

                header.editButton.setTitle("Service", for: .normal)
                header.editButton.addTarget(self, action: #selector(handleServiceButton(_:)), for: .touchUpInside)
                return header

            } else {

                header.editButton.addTarget(self, action: #selector(handleEdit(_:)), for: .touchUpInside)
                return header
            }

        default:
            assert(false, "Unexpected element kind")

        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenSize = UIScreen.main.bounds.size

        return CGSize(width: (screenSize.width - 6) / 3, height: (screenSize.width - 6) / 3)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0.0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1.5

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        // margin between cells
        return UIEdgeInsets(top: 1, left: 1, bottom: 10, right: 1)

    }

}
