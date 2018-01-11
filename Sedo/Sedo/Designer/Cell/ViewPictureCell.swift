//
//  ViewPictureCell.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/3.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class ViewPictureCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var selectedImageView: UIImageView!

    @IBOutlet weak var scrollView: UIScrollView!

    override func awakeFromNib() {

        super.awakeFromNib()

        setupImageViews()

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
    }

    func setupImageViews() {

        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)

        placeholderImageView.tintColor = .lightGray
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImageView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1.0
    }
}
