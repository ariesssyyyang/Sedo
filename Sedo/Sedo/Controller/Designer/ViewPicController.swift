//
//  ViewPicController.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/3.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit
import Nuke

class ViewPicController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cell"
    var author: Designer?
    var currentMe: Customer?
    var imageUrlString: String?
    var imageDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UINib(nibName: "ViewPictureCell", bundle: Bundle.main), forCellWithReuseIdentifier: "picCell")
        collectionView?.register(UINib(nibName: "PortfolioContentCell", bundle: Bundle.main), forCellWithReuseIdentifier: "contentCell")
        collectionView?.register(UINib(nibName: "FooterView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerViewId")

        setupNavigationBar()

    }

    // MARK: - Set up

    func setupNavigationBar() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewPost))
        self.navigationItem.title = "Portfolio"
    }

    // MARK: - Actions

    @objc func handleNewPost() {

        print("new post")
        let controller = NewPostController()
        self.present(controller, animated: true, completion: nil)

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
            contentCell.contentLabel.text = imageDescription
            return contentCell
        }

//        let url = images[indexPath.row]
//
//        if let imageURL = URL(string: url) {
//
//            cell.portfolioImageView.image = nil
//
//            Nuke.loadImage(with: imageURL, into: cell.portfolioImageView)
//
//        }

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
        return CGSize(width: screenSize.width * 5 / 6 , height: screenSize.width * 5 / 6)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0.0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0.0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        // margin between cells
        return UIEdgeInsets(top: 1, left: 1, bottom: 10, right: 1)

    }

}
