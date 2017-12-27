//
//  PortfolioCell.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class PortfolioCell: UICollectionViewCell {

    @IBOutlet weak var portfolioImageView: UIImageView!

    @IBOutlet weak var placeholderImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupImageView()
    }

    func setupImageView() {
        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)

        placeholderImageView.tintColor = UIColor.lightGray

        placeholderImageView.contentMode = .center

        portfolioImageView.contentMode = .scaleAspectFill
    }

}
