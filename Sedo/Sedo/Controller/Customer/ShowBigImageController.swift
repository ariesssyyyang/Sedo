//
//  ShowBigImageController.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/9.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit
import Nuke

class ShowBigImageController: UIViewController, UIScrollViewDelegate {
/*
    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var imageScrollView: UIScrollView!

    @IBOutlet weak var imagePageControl: UIPageControl!
*/
    var imageUrls: [String] = []
    var pageIndex: Int = 1

    let bigView: ShowBigImageView = {
        guard let view = UINib.load(nibName: "ShowBigImageView", bundle: nil) as? ShowBigImageView else { return ShowBigImageView() }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        setupBigView()

        setupButtonAction()

        bigView.imageScrollView.delegate = self

        showPortfolios()
    }

    // MARK: - Set Up

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setupBigView() {

        view.addSubview(bigView)

        bigView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bigView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bigView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bigView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }

    func setupButtonAction() {
        bigView.closeButton.addTarget(self, action: #selector(closeBigView), for: .touchUpInside)
    }

    func showPortfolios() {

        var contentWidth: CGFloat = 0.0
        let bigImageSize = UIScreen.main.bounds.size

        if imageUrls != [] {

            if imageUrls.count >= 5 {

                self.bigView.imagePageControl.numberOfPages = 5

                for i in 0...4 {

                    let xCoordinate = bigImageSize.width * CGFloat(i)

                    contentWidth += bigImageSize.width

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    bigView.imageScrollView.addSubview(scrollImageView)

                    scrollImageView.frame = CGRect(x: xCoordinate, y: 0, width: bigImageSize.width, height: bigImageSize.width)

                    let urlString = imageUrls[i]

                    if let imageURL = URL(string: urlString) {

                        scrollImageView.image = nil

                        Nuke.loadImage(with: imageURL, into: scrollImageView)

                    }

                }

                bigView.imageScrollView.contentSize = CGSize(width: contentWidth, height: bigView.imageScrollView.frame.height)

            } else if imageUrls.count == 1 {

                self.bigView.imagePageControl.isHidden = true

                let url = imageUrls[0]

                if let imageURL = URL(string: url) {

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    bigView.imageScrollView.addSubview(scrollImageView)

                    scrollImageView.frame = CGRect(x: 0, y: 0, width: bigImageSize.width, height: bigImageSize.width)

                    scrollImageView.image = nil

                    Nuke.loadImage(with: imageURL, into: scrollImageView)

                }

            } else {

                bigView.imagePageControl.numberOfPages = imageUrls.count

                for i in 0...(imageUrls.count - 1) {

                    let xCoordinate = bigImageSize.width * CGFloat(i)

                    contentWidth += bigImageSize.width

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    bigView.imageScrollView.addSubview(scrollImageView)

                    scrollImageView.frame = CGRect(x: xCoordinate, y: 0, width: bigImageSize.width, height: bigImageSize.width)

                    let urlString = imageUrls[i]

                    if let imageURL = URL(string: urlString) {

                        scrollImageView.image = nil

                        Nuke.loadImage(with: imageURL, into: scrollImageView)

                    }

                }

                bigView.imageScrollView.contentSize = CGSize(width: contentWidth, height: bigView.imageScrollView.frame.height)

            }

        } else {

            print(" no portfolio!")

        }
    }

    // MARK: - Actions

    @objc func closeBigView() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bigImageSize = UIScreen.main.bounds.size
        bigView.imagePageControl.currentPage = Int(bigView.imageScrollView.contentOffset.x / CGFloat(bigImageSize.width))
    }

}
