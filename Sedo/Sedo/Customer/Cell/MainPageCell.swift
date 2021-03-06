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

    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var textButton: UIButton!

    @IBOutlet weak var bookingButton: UIButton!

    @IBOutlet weak var designerNameLabel: UILabel!

    @IBOutlet weak var mainScrollView: MainPageScrollView!

    @IBOutlet weak var mainPageControl: UIPageControl!

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var userPlaceholderImageView: UIImageView!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.selectionStyle = .none

        self.backgroundColor = UIColor.clear

        setupImageView()

        setupLabel()

        setupBookingButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupImageView() {

        placeholderImageView.image = #imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysTemplate)

        placeholderImageView.tintColor = UIColor(
            red: 165.0 / 255.0,
            green: 170.0 / 255.0,
            blue: 178.0 / 255.0,
            alpha: 1.0
        )

        mainPageImageView.clipsToBounds = true

        mainPageImageView.layer.shadowColor = UIColor.black.cgColor

        mainPageImageView.layer.shadowRadius = 10

        mainPageImageView.layer.shadowOpacity = 0.5

        mainPageImageView.layer.shadowOffset = CGSize(width: 0, height: 0)

        userImageView.layer.cornerRadius = userImageView.frame.height

        userImageView.layer.masksToBounds = true

        userPlaceholderImageView.layer.cornerRadius = userImageView.frame.height

        userPlaceholderImageView.layer.masksToBounds = true

        userPlaceholderImageView.contentMode = .center

        userPlaceholderImageView.image = #imageLiteral(resourceName: "icon-alien").withRenderingMode(.alwaysTemplate)

        userPlaceholderImageView.tintColor = UIColor.lightGray

    }

    func setupLabel() {

        designerNameLabel.textColor = UIColor.black

    }

    func setupBookingButton() {

        textButton.layer.borderWidth = 1.0

        textButton.layer.cornerRadius = textButton.frame.size.height / 2

        textButton.layer.masksToBounds = true

        textButton.layer.borderColor = UIColor(
            red: 214.0/255,
            green: 126.0/255,
            blue: 37.0/255,
            alpha: 1.0
        ).cgColor

        textButton.setTitleColor(UIColor(
            red: 214.0/255,
            green: 126.0/255,
            blue: 37.0/255,
            alpha: 1.0
        ), for: .normal)
    }

}
