//
//  PortfolioController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Firebase

class PortfolioController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let portfolioCellId = "portfolioCell"
    var currentMe: User?
    var images: [String] = []
/*
    let introView: DesignerIntroView = {
        guard let view = UINib.load(nibName: "DesignerIntroView", bundle: nil) as? DesignerIntroView else {
            return DesignerIntroView()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

//        setupIntoView()

        fetchPortfolio()

        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UINib(nibName: "PortfolioCell", bundle: Bundle.main), forCellWithReuseIdentifier: portfolioCellId)
        collectionView?.register(UINib(nibName: "PortfolioIntroView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerViewId")
    }

    func fetchPortfolio() {
        let ref = Database.database().reference()
        let userRef = ref.child("user")

        userRef.observe(.value) { (userSnapshot) in
            guard
                let userDict = userSnapshot.value as? [String: AnyObject],
                let uid = Auth.auth().currentUser?.uid,
                let user = userDict[uid] as? [String: String],
                let name = user["name"]
            else {
                print("fail get user dict in portfolio page!")
                return
            }
            print(name)
            let portfolioRef = ref.child("portfolio").child(uid)
            portfolioRef.observe(.value, with: { (portfolioSnapshot) in
                self.images = []
                for child in portfolioSnapshot.children {
                    guard let child = child as? DataSnapshot else { return }
                    let postKey = child.key
                    guard
                        let postDict = child.value as? [String: String],
                        let description = postDict["description"],
                        let imageUrl = postDict["imageUrl"]
                    else {
                        print("fail to get post info in fetchPortfolio function!")
                        return
                    }
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]
    }

    func setupIntoView() {
        
    }

    // MARK: - Actions

    @objc func handleNewPost() {

        print("new post")
        let controller = NewPostController()
        self.present(controller, animated: true, completion: nil)

    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: portfolioCellId, for: indexPath) as? PortfolioCell else { return PortfolioCell() }
        cell.portfolioImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)
        cell.portfolioImageView.tintColor = UIColor.lightGray
        cell.portfolioImageView.contentMode = .center
        let url = images[indexPath.row]
        if let imageURL = URL(string: url) {
            DispatchQueue.global().async {
                do {
                    let downloadImage = UIImage(data: try Data(contentsOf: imageURL))
                    DispatchQueue.main.async {
                        cell.portfolioImageView.image = downloadImage
                        cell.portfolioImageView.contentMode = .scaleToFill
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width, height: 150)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewId", for: indexPath) as? PortfolioIntroView else {
            print("fail to get the right intro view")
            return PortfolioIntroView()
        }

        switch kind {
        case UICollectionElementKindSectionHeader:
            return header
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
