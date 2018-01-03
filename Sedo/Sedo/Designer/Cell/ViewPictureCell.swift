//
//  ViewPictureCell.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/3.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class ViewPictureCell: UICollectionViewCell {
    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {

        super.awakeFromNib()

        setupImageViews()
    }

    func setupImageViews() {

        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)

        placeholderImageView.tintColor = .lightGray
    }

}
