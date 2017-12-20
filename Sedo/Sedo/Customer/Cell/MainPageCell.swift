//
//  MainPageCell.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/19.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class MainPageCell: UITableViewCell {

    @IBOutlet weak var bookingButton: UIButton!

    @IBOutlet weak var designerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupNameLabel()
        setupBookingButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupNameLabel() {
        designerNameLabel.textColor = UIColor.white
    }

    func setupBookingButton() {
        bookingButton.imageView?.image = #imageLiteral(resourceName: "icon-booking").withRenderingMode(.alwaysTemplate)
        bookingButton.tintColor = UIColor.white
    }

}
