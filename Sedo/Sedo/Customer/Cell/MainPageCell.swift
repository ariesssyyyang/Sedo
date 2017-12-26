//
//  MainPageCell.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class MainPageCell: UITableViewCell {

    @IBOutlet weak var mainPageImageView: UIImageView!
    
    @IBOutlet weak var bookingButton: UIButton!

    @IBOutlet weak var designerNameLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        setupImageView()

        setupNameLabel()

        setupBookingButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupImageView() {
        mainPageImageView.clipsToBounds = true
        mainPageImageView.layer.shadowColor = UIColor.black.cgColor
        mainPageImageView.layer.shadowRadius = 10
        mainPageImageView.layer.shadowOpacity = 0.5
        mainPageImageView.layer.shadowOffset = CGSize(width: 0, height: 0)

    }

    func setupNameLabel() {

        designerNameLabel.textColor = UIColor.black

    }

    func setupBookingButton() {

        bookingButton.imageView?.image = #imageLiteral(resourceName: "icon-booking").withRenderingMode(.alwaysTemplate)

        bookingButton.tintColor = UIColor.white

    }

}
