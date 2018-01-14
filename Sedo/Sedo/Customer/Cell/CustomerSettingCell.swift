//
//  CustomerSettingCell.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/12.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class CustomerSettingCell: UITableViewCell {

    @IBOutlet weak var goImageView: UIImageView!

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var optionLabel: UILabel!

    @IBOutlet weak var logoutButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear

        setupcell()

        setupButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupcell() {

        backView.backgroundColor = UIColor.clear

        backView.layer.cornerRadius = 10

        goImageView.image = #imageLiteral(resourceName: "icon-cellgo").withRenderingMode(.alwaysTemplate)

        goImageView.tintColor = UIColor.gray

        self.selectionStyle = .none

    }

    func setupButton() {

        logoutButton.isHidden = true

        logoutButton.backgroundColor = UIColor(
            red: 133.0/255,
            green: 53.0/255,
            blue: 11.0/255,
            alpha: 1.0
        )
        let logoutString = NSLocalizedString("Log Out", comment: "")
        logoutButton.setTitle(logoutString, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Kohinoor Bangla", size: 20)
        logoutButton.layer.cornerRadius = 14
        logoutButton.layer.masksToBounds = true
    }
}
