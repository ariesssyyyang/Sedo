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

    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var imageScrollView: UIScrollView!

    @IBOutlet weak var imagePageControl: UIPageControl!

    var imageUrls: [String] = []
    var pageIndex: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        imageScrollView.delegate = self

        setupPlaceHolder()

        showPortfolios()
    }

    // MARK: - Set Up

    func setupPlaceHolder() {

        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)

        placeholderImageView.contentMode = .center

        placeholderImageView.tintColor = UIColor.lightGray

    }

    func showPortfolios() {

        var contentWidth: CGFloat = 0.0

        if imageUrls != [] {

            if imageUrls.count >= 5 {

                self.imagePageControl.numberOfPages = 5

                for i in 0...4 {

                    let xCoordinate = placeholderImageView.frame.width * CGFloat(i)

                    contentWidth += placeholderImageView.frame.width

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    imageScrollView.addSubview(scrollImageView)

                    scrollImageView.frame = CGRect(x: xCoordinate, y: placeholderImageView.frame.origin.y, width: placeholderImageView.frame.width, height: placeholderImageView.frame.height)

                    let urlString = imageUrls[i]

                    if let imageURL = URL(string: urlString) {

                        scrollImageView.image = nil

                        Nuke.loadImage(with: imageURL, into: scrollImageView)

                    }

                }

                imageScrollView.contentSize = CGSize(width: contentWidth, height: placeholderImageView.frame.height)

            } else if imageUrls.count == 1 {
                
                self.imagePageControl.isHidden = true

                let url = imageUrls[0]

                if let imageURL = URL(string: url) {

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    imageScrollView.addSubview(scrollImageView)

                    scrollImageView.image = nil

                    Nuke.loadImage(with: imageURL, into: scrollImageView)

                }

            } else {

                imagePageControl.numberOfPages = imageUrls.count

                for i in 0...(imageUrls.count - 1) {

                    let xCoordinate = placeholderImageView.frame.width * CGFloat(i)

                    contentWidth += placeholderImageView.frame.width

                    let scrollImageView = UIImageView()

                    scrollImageView.contentMode = .scaleAspectFill

                    imageScrollView.addSubview(scrollImageView)
                    
                    scrollImageView.frame = CGRect(x:xCoordinate, y: 0, width: placeholderImageView.frame.width, height: placeholderImageView.frame.height)

                    let urlString = imageUrls[i]

                    if let imageURL = URL(string: urlString) {

                        scrollImageView.image = nil
                        
                        Nuke.loadImage(with: imageURL, into: scrollImageView)

                    }

                }

                imageScrollView.contentSize = CGSize(width: contentWidth, height: placeholderImageView.frame.height)

            }

        } else {

            print(" no portfolio!")

        }
    }

    // MARK: - Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagePageControl.currentPage = Int(imageScrollView.contentOffset.x / CGFloat(placeholderImageView.frame.width))
    }

}
