//
//  ServiceCell.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var serviceItemLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
