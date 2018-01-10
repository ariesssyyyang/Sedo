//
//  ShowBigImageView.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/10.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class ShowBigImageView: UIView {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var closeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = UIColor.clear

        setupPlaceHolder()

        setupButton()
    }

    func setupPlaceHolder() {

        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)

        placeholderImageView.contentMode = .center

        placeholderImageView.tintColor = UIColor.lightGray

    }

    func setupButton() {
        closeButton.setImage(#imageLiteral(resourceName: "icon-close").withRenderingMode(.alwaysTemplate), for: .normal)

        closeButton.tintColor = UIColor.white
    }

}
