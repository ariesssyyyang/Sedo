//
//  CustomerSettingCell.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/12.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class CustomerSettingCell: UITableViewCell {

    @IBOutlet weak var separatorView: UIView!

    @IBOutlet weak var goImageView: UIImageView!

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var optionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
//            UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        setupcell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupcell() {

        separatorView.backgroundColor = UIColor.clear

        backView.backgroundColor = UIColor.clear

        backView.layer.cornerRadius = 10

        goImageView.image = #imageLiteral(resourceName: "icon-cellgo").withRenderingMode(.alwaysTemplate)

        goImageView.tintColor = UIColor.gray

        self.selectionStyle = .gray

    }
}
