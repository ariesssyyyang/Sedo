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

        placeholderImageView.tintColor = UIColor.lightGray

        customerImageView.contentMode = .scaleAspectFill

    }

    func setupLabel() {
        
    }

    func setupBackView() {

        backView.layer.cornerRadius = 20

        backView.layer.shadowColor = UIColor(
            red: 13.0/255,
            green: 92.0/255,
            blue: 127.0/255,
            alpha: 1.0
        ).cgColor

        backView.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)

        backView.layer.shadowRadius = 6

        backView.layer.shadowOpacity = 0.8
    }
}
