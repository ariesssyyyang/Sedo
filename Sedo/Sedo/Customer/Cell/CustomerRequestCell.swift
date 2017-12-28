//
//  CustomerRequestCell.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/18.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class CustomerRequestCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear

        setupBackView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupBackView() {

        backView.layer.cornerRadius = backView.frame.size.height / 2

    }

}
