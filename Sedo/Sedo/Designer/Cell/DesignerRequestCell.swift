//
//  DesignerRequestCell.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class DesignerRequestCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var customerImageView: UIImageView!

    @IBOutlet weak var placeholderImageView: UIImageView!

    @IBOutlet weak var serviceLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.backgroundColor = UIColor.clear

        setupImageView()

        setupBackView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupImageView() {

        placeholderImageView.image = #imageLiteral(resourceName: "icon-alien").withRenderingMode(.alwaysTemplate)

        placeholderImageView.contentMode = .center

        placeholderImageView.tintColor = UIColor.white

        customerImageView.contentMode = .scaleAspectFill

        customerImageView.layer.cornerRadius = customerImageView.frame.height / 2

        customerImageView.clipsToBounds = true

    }

    func setupBackView() {

        backView.backgroundColor = UIColor(
            red: 13.0/255,
            green: 92.0/255,
            blue: 127.0/255,
            alpha: 0.5
        )

        backView.layer.cornerRadius = 20
/*
        backView.layer.shadowColor = UIColor(
            red: 254.0 / 255.0,
            green: 158.0 / 255.0,
            blue: 40 / 255.0,
            alpha: 1.0
        ).cgColor

        backView.layer.shadowColor = UIColor(
            red: 13.0/255,
            green: 92.0/255,
            blue: 127.0/255,
            alpha: 1.0
        ).cgColor

        backView.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)

        backView.layer.shadowRadius = 5

        backView.layer.shadowOpacity = 0.8
*/
    }
}
